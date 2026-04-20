# frozen_string_literal: true

module Telesink
  module ActiveJob
    class Railtie < ::Rails::Railtie
      initializer "telesink.active_job" do
        ActiveSupport.on_load(:active_job) do
          include Telesink::ActiveJob::Telesinkable
        end
      end
    end
  end
end
