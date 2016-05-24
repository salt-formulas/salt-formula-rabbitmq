{%- from "rabbitmq/map.jinja" import server with context -%}
#!/bin/bash -e

salt-call --local --retcode-passthrough state.highstate
service {{ server.service }} stop || true

su rabbitmq --shell=/bin/sh -c '/usr/lib/rabbitmq/bin/rabbitmq-server'

{#-
vim: syntax=jinja
-#}
