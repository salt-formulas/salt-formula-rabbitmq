include:
- rabbitmq.server.service
- rabbitmq.server.ssl

{%- if not grains.get('noservices', False) %}
- rabbitmq.server.plugin
- rabbitmq.server.vhost
- rabbitmq.server.user
{%- endif %}
