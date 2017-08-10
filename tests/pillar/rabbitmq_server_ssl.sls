rabbitmq:
  server:
    enabled: true
    bind:
      address: 0.0.0.0
      port: 5672
    secret_key: rabbit_master_cookie
    admin:
      name: adminuser
      password: pwd
    ssl:
      enabled: True
      cert_file: /etc/rabbitmq/ssl/cert.pem
      key_file: /etc/rabbitmq/ssl/key.pem
      ca_file: /etc/rabbitmq/ssl/ca.pem
      cert: |
        -----BEGIN CERTIFICATE-----
        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
        P7LMX9o0aO26Og9TfD6JOhCvwTk=
        -----END CERTIFICATE-----
      key: |
        -----BEGIN RSA PRIVATE KEY-----
        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
        -----END RSA PRIVATE KEY-----
      cacert_chain: |
        -----BEGIN CERTIFICATE-----
        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
        /86PB1o=
        -----END CERTIFICATE-----
    host:
      '/':
        enabled: true
        user: guest
        password: guest
        policies:
        - name: HA
          pattern: '^(?!amq\.).*'
          definition: '{"ha-mode": "all"}'
    memory:
      vm_high_watermark: 0.4
    plugins: ['']
