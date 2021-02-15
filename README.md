# fluent-plugin-out-kafka-rest, a plugin for [Fluentd](http://fluentd.org) (WIP)

A [fluentd][1] output plugin for sending logs to Kafka REST Proxy.
This plugin does not use the native library of Apache Kafka itself.
Please refer to Confluent's [kakfa-rest](https://github.com/confluentinc/kafka-rest)
for the detail of REST Proxy service.

## Configs

    <match *>
      type            kafka_rest
      endpoint_url    http://localhost.local:8082/topics/topic
      token           authtoken
      # use_ssl         false
      # rate_limit_msec 0
    </match>

## use https

When you use https instead of http,
set "use_ssl" to true.

The following is an example.

    <match *>
      type            kafka_rest
      endpoint_url    https://localhost.local:8082/topics/topic
      token           authtoken
      use_ssl         true
      # rate_limit_msec 0
    </match>

I simply tested https mode with AWS's ELB.

IMAGE

 fluentd --> ELB --> Kafka REST Proxy --> Kafka

## ToDo

* Change tests
* Fix the function to include tags and timestamps.
  We should include such information into the request body.
* Add function to submit multiple records at once.
* Avro support

## Note

* Set `use_ssl` to true to use https connection
* Set `include_tag` to true to include fluentd tag in the event log as a property 
* Set `include_timestamp` to true to include timestamp (UNIX time) in the event log as a property
* By default, it does not verify the https server. Use VERIFY_PEER and place the cert.pem to the location specified by OpenSSL::X509::DEFAULT_CERT_FILE. 
* Majority of the code are cloned from  [fluent-plugin-out-https][2]

  [1]: http://fluentd.org/
  [2]: https://github.com/kazunori279/fluent-plugin-out-https
