
{%- if pillar.rabbitmq is defined %}
include:
- rabbitmq.server
{%- if pillar.rabbitmq.cluster is defined and not grains.get('noservices', False) %}
- rabbitmq.cluster
{%- endif %}
{%- endif %}
