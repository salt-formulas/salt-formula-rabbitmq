{%- from "rabbitmq/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- rabbitmq.server.service

{%- if server.admin is defined %}

rabbit_user_admin_present:
  rabbitmq_user.present:
  - name: {{ server.admin.name }}
  - password: {{ server.admin.password }}
  - force: True
  - tags: management administrator
  - perms:
    {%- for vhost_name, vhost in server.get('host', {}).iteritems() %}
    - '{{ vhost_name }}':
      - '.*'
      - '.*'
      - '.*'
    {%- endfor %}
  - require:
    - service: rabbitmq_service

{%- endif %}

{%- endif %}