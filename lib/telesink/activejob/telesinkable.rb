# frozen_string_literal: true

module Telesink
  module ActiveJob
    module Telesinkable
      extend ActiveSupport::Concern

      included do
        after_enqueue do |job|
          next unless enabled?

          Telesink.track(
            event: "Job enqueued",
            text: "#{self.class.name} · #{job.queue_name}",
            emoji: "📬",
            properties: job_properties(job),
            idempotency_key: "enqueue-#{job.job_id}",
            endpoint: activejob_endpoint
          )
        end

        around_perform do |job, block|
          start_mono = Process.clock_gettime(Process::CLOCK_MONOTONIC)

          next unless enabled?

          Telesink.track(
            event: "Job started",
            text: "#{self.class.name} · #{job.queue_name}",
            emoji: "🏃",
            properties: job_properties(job).merge(started_at: Time.current.iso8601),
            idempotency_key: "start-#{job.job_id}",
            endpoint: activejob_endpoint
          )

          block.call

          duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_mono) * 1000).round
          Telesink.track(
            event: "Job succeeded",
            text: "#{self.class.name} · #{duration_ms}ms",
            emoji: "✅",
            properties: job_properties(job).merge(duration_ms: duration_ms),
            idempotency_key: "success-#{job.job_id}",
            endpoint: activejob_endpoint
          )
        rescue StandardError => exception
          duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_mono) * 1000).round
          Telesink.track(
            event: "Job failed",
            text: "#{self.class.name} (#{exception.class.name})",
            emoji: "❌",
            properties: job_properties(job).merge(
              error_class: exception.class.name,
              error_message: exception.message,
              backtrace: exception.backtrace&.first(5),
              duration_ms: duration_ms
            ),
            idempotency_key: "fail-#{job.job_id}",
            endpoint: activejob_endpoint
          )
          raise
        end
      end

      private

      def job_properties(job)
        {
          job_class: self.class.name,
          job_id: job.job_id,
          queue: job.queue_name,
          priority: job.priority,
          scheduled_at: job.scheduled_at&.iso8601,
          arguments: job.arguments,
          attempts: job.respond_to?(:attempts) ? job.attempts : nil
        }.compact
      end

      def activejob_endpoint
        ENV["TELESINK_ACTIVEJOB_ENDPOINT"] || ENV["TELESINK_ENDPOINT"]
      end

      def enabled?
        ENV["TELESINK_DISABLED"].to_s.empty?
      end
    end
  end
end
