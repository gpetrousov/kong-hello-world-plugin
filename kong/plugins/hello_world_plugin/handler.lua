local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1",
}


function hello_world_plugin:init_worker()
  kong.log("Hello world plugin init_worker...")
end

--[[ runs in the 'ssl_certificate_by_lua_block'
-- IMPORTANT: during the `certificate` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the hello_world_plugin is
-- configured as a global hello_world_plugin!
function hello_world_plugin:certificate(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'certificate' handler")

end --]]



--[[ runs in the 'rewrite_by_lua_block'
-- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the hello_world_plugin is
-- configured as a global hello_world_plugin!
function hello_world_plugin:rewrite(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")

end --]]



-- runs in the 'access_by_lua_block'
function hello_world_plugin:access(plugin_conf)

  -- your custom code here
  kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!
  kong.service.request.set_header(plugin_conf.request_header, "this is on a request")

end


--[[ runs in the 'header_filter_by_lua_block'
function hello_world_plugin:header_filter(plugin_conf)

  -- your custom code here, for example;
  kong.response.set_header(plugin_conf.response_header, "this is on the response")

end --]]


--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'body_filter' handler")

end --]]


--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")

end --]]


-- return our plugin object
return hello_world_plugin
