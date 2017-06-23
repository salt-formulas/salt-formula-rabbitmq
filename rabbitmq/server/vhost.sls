{%- from "rabbitmq/map.jinja" import server with context %}
{%- if server.enabled %}

{%- for host_name, host in server.get('host', {}).iteritems() %}

{%- if host.enabled %}

{%- if host_name != '/' %}
rabbitmq_vhost_{{ host_name }}:
  rabbitmq_vhost.present:
  - name: {{ host_name }}
  - require:
    - service: rabbitmq_service
  - require_in:
    - rabbitmq_user: rabbitmq_user_{{ host.user }}
{%- endif %}

rabbitmq_user_{{ host.user }}:
  rabbitmq_user.present:
  - name: {{ host.user }}
  - password: {{ host.password }}
  - force: true
  - perms:
    - '{{ host_name }}':
      - '.*'
      - '.*'
      - '.*'

{%- for policy in host.get('policies', []) %}

rabbitmq_policy_{{ host_name }}_{{ policy.name }}:
  rabbitmq_policy.present:
  - name: {{ policy.name }}
  - pattern: {{ policy.pattern }}
  - definition: {{ policy.definition|json }}
  - priority: {{ policy.get('priority', 0)|int }}
  - vhost: {{ host_name }}
  - require:
    - service: rabbitmq_service

{%- endfor %}

{%- else %}

rabbitmq_vhost_{{ host_name }}:
  rabbitmq_vhost.absent:
  - name: {{ host_name }}
  - require:
    - service: rabbitmq_service

rabbitmq_user_{{ host.user }}:
  rabbitmq_user.absent:
  - name: {{ host.user }}
  - require:
    - service: rabbitmq_service

{%- endif %}

{%- endfor %}

{%- endif %}
