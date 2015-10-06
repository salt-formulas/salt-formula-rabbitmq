
include:
{% if pillar.rabbitmq.server is defined %}
- rabbitmq.server
{% endif %}
{% if pillar.rabbitmq.cluster is defined %}
- rabbitmq.cluster
{% endif %}
