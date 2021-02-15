require 'net/https'
require 'openssl'
require 'uri'
require 'yajl'
require 'base64'
require 'fluent/plugin/output'
require 'json'
module Fluent::Plugin
  class KafkaRestOutput < Output
    Fluent::Plugin.register_output('kafka_rest', self)
    helpers :formatter
    def initialize
        @formatter = nil
        super
    end
    # https or http
    config_param :use_ssl, :bool, :default => false

    # # include tag
    # config_param :include_tag, :bool, :default => false

    # # include timestamp
    # config_param :include_timestamp, :bool, :default => false

    # Endpoint URL ex. localhost.local/api/
    config_param :endpoint_url, :string

    # HTTP method
    config_param :http_method, :string, :default => :post
    
    # json ( Should support avro in the future)
    config_param :serializer, :string, :default => :json

    # Content-Type
    config_param :content_type, :string, :default => 'application/json'

    # Simple rate limiting: ignore any records within `rate_limit_msec`
    # since the last one.
    config_param :rate_limit_msec, :integer, :default => 0
    config_section :format do
        config_set_default :@type, 'json'
    end
    # nil | 'none' | 'basic'
    #config_param :authentication, :string, :default => nil 
    config_param :username, :string, :default => ''
    config_param :password, :string, :default => ''
    config_param :token, :string, :default => ''
    def configure(conf)
      super

      @use_ssl = conf['use_ssl']
    #   @include_tag = conf['include_tag']
    #   @include_timestamp = conf['include_timestamp']
      @formatter = formatter_create
      define_singleton_method(:format, method(:format_json_array))
      serializers = [:json]  # Should support :avro in the future
      @serializer = if serializers.include? @serializer.intern
                      @serializer.intern
                    else
                      :json
                    end

      @content_type = conf['content_type']

      # Kafka REST Proxy accepts only POST method at the moment
      http_methods = [:post]
      @http_method = if http_methods.include? @http_method.intern
                      @http_method.intern
                    else
                      :post
                    end

      # @auth = case @authentication
      #         when 'basic' then :basic
      #         when 'bearer' then :bearer
      #         else
      #           :none
      #         end
    end

    def start
      super
    end

    def shutdown
      super
    end

    def format_url()
      @endpoint_url
    end
    def formatted_to_msgpack_binary?
    @formatter_configs.first[:@type] == 'msgpack'
    end
  
    def format(tag, time, record)
    @formatter.format(tag, time, record)
    end

    def format_json_array(tag, time, record)
    record["time"] = time * 1000
    @formatter.format(tag, time, record) << ","
    end
    def set_body(req, chunk)
      # TODO: Add avro support
    #   if @include_tag
    #     record['tag'] = tag
    #   end
    #   if @include_timestamp
    #     record['timestamp'] = Time.now.to_i
    #   end 
      if @serializer == :json
        set_json_body(req, chunk)
      # elsif @serializer == :avro
      #   set_avro_body(req, record)
      end
      req
    end

    def set_header(req)
      req['Content-Type'] = 'application/vnd.kafka.json.v2+json'
      req['Accept'] = 'application/vnd.kafka.v2+json'
      req['Authorization'] = @token
      req
    end

    def set_json_body(req, chunk)
      payload = {}
      payload["records"] = []
      parsed = JSON.parse("[#{chunk.read.chop}]")
      parsed.each { |record| 
      value = {}
      value["value"] = record
      payload["records"].append(value)
      }
      req.body = Yajl.dump(payload)
    end

    def set_avro_body(req, data)
      # TODO: Implement avro body parser
    end

    def create_request(chunk)
      url = format_url()
      uri = URI.parse(url)
      req = Net::HTTP.const_get(@http_method.to_s.capitalize).new(uri.path)
      set_body(req, chunk)
      set_header(req)
      return req, uri
    end

    def send_request(req, uri)    
      is_rate_limited = (@rate_limit_msec != 0 and not @last_request_time.nil?)
      if is_rate_limited and ((Time.now.to_f - @last_request_time) * 1000.0 < @rate_limit_msec)
        $log.info('Dropped request due to rate limiting')
        return
      end
      
      res = nil
      begin
        @last_request_time = Time.now.to_f
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = @use_ssl
        https.ca_file = OpenSSL::X509::DEFAULT_CERT_FILE 
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = https.start {|http| http.request(req) }
        $log.info(req.body)
        $log.info(res.code)
        $log.info(res.body)
      rescue IOError, EOFError, SystemCallError
        # server didn't respond
        $log.warn "Net::HTTP.#{req.method.capitalize} raises exception: #{$!.class}, '#{$!.message}'"
      end
      unless res and res.is_a?(Net::HTTPSuccess)
        res_summary = if res
                        "#{res.code} #{res.message} #{res.body}"
                      else
                        "res=nil"
                      end
        $log.warn "failed to #{req.method} #{uri} (#{res_summary})"
      end
    end

    def handle_chunks(chunk)
      req, uri = create_request(chunk)
      send_request(req, uri)
    end

    def write(chunk)
       handle_chunks(chunk)
    end
  end
end
