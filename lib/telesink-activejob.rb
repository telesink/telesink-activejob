# frozen_string_literal: true

require "active_job"
require_relative "telesink/activejob/version"
require_relative "telesink/activejob/telesinkable"

require_relative "telesink/activejob/railtie" if defined?(Rails)
