{%- from "rabbitmq/map.jinja" import server,cluster with context -%}
#!/bin/bash -e

cat /srv/salt/pillar/rabbitmq-server.sls | envsubst > /tmp/rabbitmq-server.sls
mv /tmp/rabbitmq-server.sls /srv/salt/pillar/rabbitmq-server.sls

{%- if cluster.get('enabled', False) %}

# if NUM_NODES not passed, default to 3
NUM_NODES=${NUM_NODES:-3}

# loop through number of nodes
for num in `seq 1 $NUM_NODES`; do
  NODE_SERVICE_HOST="RABBITMQ_SERVER_NODE0${num}_SERVICE_HOST"

  # if set
  if [ -n "${!NODE_SERVICE_HOST}" ]; then
    # if not its own IP, then add it
    if [ $(expr "$HOSTNAME" : "rabbitmq-server-node0${num}") -eq 0 ]; then
      # set role cluster role slave for salt
      sed -i -e 's,^\([\ \t]*role: \)[Nn]one,\1slave,g' /srv/salt/pillar/rabbitmq-server.sls
      # set master dns for cluster join
      sed -i -e 's,^\([\ \t]*master: \)[Nn]one,\1rabbitmq-server-node0'${num}',g' /srv/salt/pillar/rabbitmq-server.sls
      break
    else
      # set role cluster role master for salt
      sed -i -e 's,^\([\ \t]*role: \)[Nn]one,\1master,g' /srv/salt/pillar/rabbitmq-server.sls
    fi
  fi
done

{%- endif %}

salt-call --local --retcode-passthrough state.highstate
service {{ server.service }} stop || true

su rabbitmq --shell=/bin/sh -c '/usr/lib/rabbitmq/bin/rabbitmq-server'

{#-
vim: syntax=jinja
-#}
