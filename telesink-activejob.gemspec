Gem::Specification.new do |spec|
  spec.name        = "telesink-activejob"
  spec.version     = Telesink::ActiveJob::VERSION
  spec.authors     = ["Kyrylo Silin"]
  spec.email       = ["kyrylo@telesink.com"]
  spec.summary     = "ActiveJob integration for Telesink"
  spec.description = "Automatically tracks job enqueue/start/success/failure events to Telesink."
  spec.homepage    = "https://github.com/telesink/telesink-activejob"
  spec.license     = "MIT"

  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "telesink", ">= 1.3.0"
  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "activejob", ">= 6.0"

  spec.required_ruby_version = ">= 3.0"
end
