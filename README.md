# kong-run-command-plugin

This is a barebones `Kong` plugin I put together in a few hours to showcase how someone can use `Kong` as an execution server. The server accepts an arbitrary `command` with `arguments` - either throught the URL or request headers - and executes it as a script.

Checkout my [blogpost on Medium](https://medium.com/@petrousov/custom-kong-plugins-revisited-c20a96719122)

**Note**

A note of warning is required here. The plugin will run absolutely any command it's allowed to making `Kong` [command injection](https://owasp.org/www-community/attacks/Command_Injection) vulnerable. Use at your own risk.

## Usage and installation

1. Start the `kong` container

```
docker run -it --rm --name kong-dbless-dev \
  --network=kong-gw \
  -v "$(pwd):/kong/declarative/" \
  -e "KONG_DATABASE=off" \
  -e "KONG_DECLARATIVE_CONFIG=/kong/declarative/kong.yml" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  --user 0:0 \
kong/kong-gateway:3.2.2.1 bash
```

2. Validate config

```
kong config -c kong.conf parse kong.yml
```

3. Install plugin

```
luarocks make
```

4. Check the plugin is installed

```
/usr/local/lib/luarocks/rocks-5.1/kong-hello-world-plugin
```

5. Start kong

```
export KONG_DATABASE=off
kong start -c kong.conf
```

6. Test the plugin is working

You should see the output in the container logs.

```
curl -X GET -IL http://localhost:8000/hello_world_path\?cmd\=ls\&arg\=-l
```
