{%- from "rabbitmq/map.jinja" import server with context %}

{%- if server.ssl.enabled %}

rabbitmq_cacertificate:
  file.managed:
    - name: {{ server.ssl.ca_file }}
    {%- if server.ssl.cacert_chain is defined %}
    - contents_pillar: rabbitmq:server:ssl:cacert_chain
    {%- else %}
    - source: salt://pki/{{ server.ssl.authority }}/certs/ca.cert
    {%- endif %}
    - user: root
    - group: rabbitmq
    - mode: 640
    - makedirs: true

rabbitmq_certificate:
  file.managed:
    - name: {{ server.ssl.cert_file }}
    {%- if server.ssl.cert is defined %}
    - contents_pillar: rabbitmq:server:ssl:cert
    {%- else %}
    - source: salt://pki/{{ server.ssl.authority }}/certs/rabbitmq.cert
    {%- endif %}
    - user: root
    - group: rabbitmq
    - mode: 640
    - makedirs: true

rabbitmq_server_key:
  file.managed:
    - name: {{ server.ssl.key_file }}
    {%- if server.ssl.key is defined %}
    - contents_pillar: rabbitmq:server:ssl:key
    {%- else %}
    - source: salt://pki/{{ server.ssl.authority }}/certs/rabbitmq.key
    {%- endif %}
    - user: root
    - group: rabbitmq
    - mode: 640
    - makedirs: true

# consist of private key and cert
rabbitmq_ssl_all_file:
  file.managed:
    - name: {{ server.ssl.all_file }}
    - source: salt://rabbitmq/files/ssl/all_file.pem.j2
    - template: jinja
    - user: root
    - group: rabbitmq
    - mode: 640
    - makedirs: true
    - context:
        ssl_key_file: {{ server.ssl.key_file }}
        ssl_crt_file: {{ server.ssl.cert_file }}
    - watch:
      - file: rabbitmq_server_key
      - file: rabbitmq_certificate

rabbitmq_ssl_env:
  file.managed:
    - name: {{ server.env_file }}
    - source: salt://rabbitmq/files/ssl/ssl_env.conf.j2
    - template: jinja
    - user: root
    - group: rabbitmq
    - mode: 640
    - makedirs: true
    - context:
       all_file: {{ server.ssl.all_file }}
       ca_file: {{ server.ssl.ca_file }}

{%- endif %}
