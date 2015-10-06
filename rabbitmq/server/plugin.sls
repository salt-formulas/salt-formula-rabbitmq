{%- from "rabbitmq/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- rabbitmq.server.service

{%- for plugin in server.get('plugins', []) %}

rabbitmq_plugin_{{ plugin }}:
  rabbitmq_plugin.enabled:
  - name: {{ plugin }}
  - require:
    - service: rabbitmq_service

{%- endfor %}

{%- endif %}