# fluent-plugin-out-kafka-rest, a plugin for [Fluentd](http://fluentd.org)

A generic [fluentd][1] output plugin for sending logs to an HTTP and HTTPS endpoint.

## Configs

    <match *>
      type            kafka-rest
      use_ssl         true
      include_tag     true
      include_timestamp true
      endpoint_url    https://localhost.local/api/
      http_method     post
      serializer      json
      rate_limit_msec 100
      # authentication  basic
      # username        alice
      # password        bobpop
    </match>

## Note

* Set `use_ssl` to true to use https connection
* Set `include_tag` to true to include fluentd tag in the event log as a property 
* Set `include_timestamp` to true to include timestamp (UNIX time) in the event log as a property
* By default, it does not verify the https server. Use VERIFY_PEER and place the cert.pem to the location specified by OpenSSL::X509::DEFAULT_CERT_FILE. 
* Majority of the code are cloned from  [fluent-plugin-out-https][2]

  [1]: http://fluentd.org/
  [2]: https://github.com/kazunori279/fluent-plugin-out-https
