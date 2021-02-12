# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-out-kafka-rest"
  gem.version       = "0.1.1.2"
  gem.authors       = ["dobachi"]
  gem.email         = ["dobachi1983oss@gmail.com"]
  gem.summary       = %q{A fluentd output plugin for sending logs to Kafka REST Proxy}
  gem.description   = gem.summary
  gem.homepage      = "https://github.com/dobachi/fluent-plugin-out-kafka-rest"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "yajl-ruby", "~> 1.0"
  gem.add_runtime_dependency "fluentd", "~> 1.12.0"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
end
