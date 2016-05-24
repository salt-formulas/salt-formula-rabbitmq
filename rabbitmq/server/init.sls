include:
- rabbitmq.server.service
{%- if not grains.get('noservices', False) %}
- rabbitmq.server.plugin
- rabbitmq.server.vhost
- rabbitmq.server.user
{%- endif %}
