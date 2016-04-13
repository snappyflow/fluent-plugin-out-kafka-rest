# fluent-plugin-out-kafka-rest, a plugin for [Fluentd](http://fluentd.org) (WIP)

A [fluentd][1] output plugin for sending logs to Kafka REST Proxy.
This plugin does not use the native library of Apache Kafka itself.
Please refer to Confluent's [kakfa-rest](https://github.com/confluentinc/kafka-rest)
for the detail of REST Proxy service.

## Configs

    <match *>
      type            kafka_rest
      endpoint_url    https://localhost.local/api/
      # use_ssl         false
      # include_tag     false
      # include_timestamp false
      # http_method     post
      # serializer      one
      # rate_limit_msec 0
      # authentication  basic  # default: nil
      # username        alice
      # password        bobpop
    </match>

## ToDo

* Change tests
* Fix the function to include tags and timestamps.
  We should include such information into the request body.
* Add function to submit multiple records at once.
* Try SSL via ELB
* Avro support

## Note

* Set `use_ssl` to true to use https connection
* Set `include_tag` to true to include fluentd tag in the event log as a property 
* Set `include_timestamp` to true to include timestamp (UNIX time) in the event log as a property
* Set `serializer` to any to use your own serializer rule except for Kafka REST Proxy's JSON protocol
* By default, it does not verify the https server. Use VERIFY_PEER and place the cert.pem to the location specified by OpenSSL::X509::DEFAULT_CERT_FILE. 
* Majority of the code are cloned from  [fluent-plugin-out-https][2]

  [1]: http://fluentd.org/
  [2]: https://github.com/kazunori279/fluent-plugin-out-https
