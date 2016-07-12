{%- from "rabbitmq/map.jinja" import cluster with context %}
{%- if cluster.enabled %}

include:
- linux.network.host
- rabbitmq.server.service

{% if cluster.get('role', 'slave') == 'master' %}

rabbitmq_cluster_init:
  cmd.run:
  - names:
    - rabbitmqctl set_cluster_name {{ cluster.get('name', 'rabbitmq') }}
  - unless: test -e /var/lib/rabbitmq/.cluster-installed
  - require:
    - service: rabbitmq_service

{% else %}

rabbit@master:
  rabbitmq_cluster.join:
  - user: rabbit
  - host: {{ cluster.master }}
  {%- if cluster.get('mode', 'disc') == 'ram' %}
  - ram_node: true
  {%- endif %}
  - require:
    - service: rabbitmq_service

{%- endif %}

rabbitmq_cluster_init_final:
  cmd.run:
  - names:
    - touch /var/lib/rabbitmq/.cluster-installed
  - unless: test -e /var/lib/rabbitmq/.cluster-installed
  - require:
    - service: rabbitmq_service

{%- endif %}
