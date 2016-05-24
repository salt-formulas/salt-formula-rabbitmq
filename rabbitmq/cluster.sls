{%- from "rabbitmq/map.jinja" import cluster with context %}
{%- if cluster.enabled %}

include:
- linux.network.host
- rabbitmq.server.service

rabbitmq_dirs:
  file.directory:
  - names:
    - /root/rabbitmq/flags
  - mode: 700
  - user: root
  - group: root
  - makedirs: true

{% if cluster.get('role', 'slave') == 'master' %}

rabbitmq_cluster_init:
  cmd.run:
  - names:
    - rabbitmqctl set_cluster_name {{ cluster.get('name', 'rabbitmq') }}
  - unless: test -e /root/rabbitmq/flags/cluster-installed
  - require:
    - file: rabbitmq_dirs
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
    - file: rabbitmq_dirs
    - service: rabbitmq_service

{%- endif %}

rabbitmq_cluster_init_final:
  cmd.run:
  - names:
    - touch /root/rabbitmq/flags/cluster-installed
  - unless: test -e /root/rabbitmq/flags/cluster-installed
  - require:
    - file: rabbitmq_dirs
    - service: rabbitmq_service

{%- endif %}
