# fluent-plugin-out-https, a plugin for [Fluentd](http://fluentd.org)

A generic [fluentd][1] output plugin for sending logs to an HTTPS endpoint.

## Configs

    <match *>
      type https
      endpoint_url    https://localhost.local/api/
      http_method     put
      serializer      json
      rate_limit_msec 100
      authentication  basic
      username        alice
      password        bobpop
    </match>

----

Majority of the code are cloned from  [fluent-plugin-out-http][2]

  [1]: http://fluentd.org/
  [2]: https://github.com/tagomoris/fluent-plugin-out-http
