
{%- if pillar.rabbitmq is defined %}
include:
- rabbitmq.server
{%- if pillar.rabbitmq.cluster is defined %}
- rabbitmq.cluster
{%- endif %}
{%- endif %}
