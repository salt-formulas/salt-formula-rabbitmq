{%- from "rabbitmq/map.jinja" import cluster with context %}
{%- if cluster.enabled %}

include:
- rabbitmq.server.service

{% if cluster.get('role', 'None') == 'master' %}

rabbitmq_cluster_name:
  cmd.run:
  - name: >
      rabbitmqctl set_cluster_name {{ cluster.get('name', 'rabbitmq') }} &&
      echo "{{ cluster.get('name', 'rabbitmq') }}" > /var/lib/rabbitmq/.cluster_name
  - creates: /var/lib/rabbitmq/.cluster_name
  - require:
    - service: rabbitmq_service

{% elif cluster.get('role', 'None') == 'slave' %}

rabbit@master:
  rabbitmq_cluster.join:
  - user: rabbit
  - host: {{ cluster.master }}
  {%- if cluster.get('mode', 'disc') == 'ram' %}
  - ram_node: true
  {%- endif %}
  - require:
    - service: rabbitmq_service

{%- else %}

{# Container deployment role independent #}

{%- endif %}

{%- endif %}
