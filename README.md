# fluent-plugin-out-https, a plugin for [Fluentd](http://fluentd.org)

A generic [fluentd][1] output plugin for sending logs to an HTTP and HTTPS endpoint.

## Configs

    <match *>
      type            http
      use_ssl         true
      endpoint_url    https://localhost.local/api/
      http_method     post
      serializer      json
      rate_limit_msec 100
      authentication  basic
      username        alice
      password        bobpop
    </match>

## Note

* By default, it does not verify the https server. Use VERIFY_PEER and place the cert.pem to the location specified by OpenSSL::X509::DEFAULT_CERT_FILE. 
* Majority of the code are cloned from  [fluent-plugin-out-http][2]

  [1]: http://fluentd.org/
  [2]: https://github.com/ento/fluent-plugin-out-http
