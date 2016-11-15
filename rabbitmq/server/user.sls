{%- from "rabbitmq/map.jinja" import server, rabbitmq_users with context %}
{%- if server.enabled %}

include:
- rabbitmq.server.service

{%- if server.admin is defined %}

rabbit_user_admin_present:
  rabbitmq_user.present:
  - name: {{ server.admin.name }}
  - password: {{ server.admin.password }}
  - force: True
  - tags: administrator
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

{%- if 'guest' not in rabbitmq_users.keys() %}
{#- Delete default guest user if we are not using it #}
rabbitmq_user_guest_absent:
  rabbitmq_user.absent:
  - name: guest
  - require:
    - service: rabbitmq_service
{%- endif %}

{%- endif %}
