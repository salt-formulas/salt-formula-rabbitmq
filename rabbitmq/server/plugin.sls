{%- from "rabbitmq/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- rabbitmq.server.service

{%- for plugin in server.get('plugins', []) %}

rabbitmq_plugin_{{ plugin }}:
  rabbitmq_plugin.enabled:
  - name: {{ plugin }}
  {%- if server.plugins_runas_user is defined %}
  - runas: {{ server.plugins_runas_user }}
  {%- endif %}
  - require:
    - service: rabbitmq_service

{%- endfor %}

{%- endif %}
