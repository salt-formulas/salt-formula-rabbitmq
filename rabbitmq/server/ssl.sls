{%- from "rabbitmq/map.jinja" import server with context %}

{%- if server.ssl.enabled %}

{%- if server.ssl.cacert_chain is defined %}
rabbitmq_cacertificate:
  file.managed:
    - name: {{ server.ssl.ca_file }}
    - contents_pillar: rabbitmq:server:ssl:cacert_chain
    - mode: 640
    - user: root
    - group: rabbitmq
    - makedirs: true
{%- else %}
rabbitmq_cacertificate_exists:
 file.exists:
   - name: {{ server.ssl.ca_file }}
rabbitmq_cacertificate:
  file.managed:
  - name: {{ server.ssl.ca_file }}
  - mode: 644
  - user: root
  - group: rabbitmq
  - create: False
  - require:
    - file: rabbitmq_cacertificate_exists
{%- endif %}

{%- if server.ssl.cert is defined %}
rabbitmq_certificate:
  file.managed:
    - name: {{ server.ssl.cert_file }}
    - contents_pillar: rabbitmq:server:ssl:cert
    - mode: 640
    - user: root
    - group: rabbitmq
    - makedirs: true
{%- else %}
rabbitmq_certificate_exists:
  file.exists:
  - name: {{ server.ssl.cert_file }}
rabbitmq_certificate:
  file.managed:
  - name: {{ server.ssl.cert_file }}
  - mode: 640
  - user: root
  - group: rabbitmq
  - create: False
  - require:
    - file: rabbitmq_certificate_exists
{%- endif %}

{%- if server.ssl.key is defined %}
rabbitmq_server_key:
  file.managed:
    - name: {{ server.ssl.key_file }}
    - contents_pillar: rabbitmq:server:ssl:key
    - user: root
    - group: rabbitmq
    - mode: 640
    - makedirs: true
{%- else %}
rabbitmq_server_key_exists:
  file.exists:
    - name: {{ server.ssl.key_file }}
rabbitmq_server_key:
  file.managed:
    - name: {{ server.ssl.key_file }}
    - mode: 640
    - user: root
    - group: rabbitmq
    - create: False
    - require:
      - file: rabbitmq_server_key_exists
{%- endif %}

{%- if server.ssl.cert is defined or server.ssl.key is defined %}
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
{%- else %}
rabbitmq_ssl_all_file_exists:
  file.exists:
    - name: {{ server.ssl.all_file }}
rabbitmq_ssl_all_file:
  file.managed:
    - name: {{ server.ssl.all_file }}
    - mode: 640
    - user: root
    - group: rabbitmq
    - create: False
    - require:
      - file: rabbitmq_server_key_exists
{%- endif %}

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
