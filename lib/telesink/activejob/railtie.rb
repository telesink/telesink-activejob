# frozen_string_literal: true

module Telesink
  module ActiveJob
    class Railtie < ::Rails::Railtie
      config.to_prepare do
        ActiveJob::Base.include Telesink::ActiveJob::Telesinkable
      end
    end
  end
end
