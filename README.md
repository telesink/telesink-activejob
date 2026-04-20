# telesink-activejob

ActiveJob integration for [Telesink](https://telesink.com).

Automatically tracks job lifecycle events (`enqueued`, `started`, `succeeded`,
`failed`) for any ActiveJob backend (Solid Queue, Sidekiq, etc.).

## Installation

Add to your `Gemfile`:

```ruby
gem "telesink-activejob"
```

Then run:

```sh
bundle install
```

## Configuration

No extra setup needed. It uses the same `TELESINK_ENDPOINT` as the core gem.

To send job events to a **separate sink** (recommended for folders):

```sh
export TELESINK_ACTIVEJOB_ENDPOINT=https://app.telesink.com/api/v1/sinks/your_jobs_sink_token/events
```

## How it works

Every job that inherits from `ApplicationJob` (or any `ActiveJob::Base`)
automatically gets:

- `Job enqueued` (with queue name)
- `Job started` (with queue name)
- `Job succeeded` (with duration)
- `Job failed` (with error details)

Events are sent using the same conventions as the [core SDK](https://github.com/telesink/telesink-ruby).

## Manual opt-in (if you prefer)

```ruby
class MyJob < ApplicationJob
  include Telesink::ActiveJob::Telesinkable
  # ...
end
```

## License

MIT (see [LICENSE.md](/LICENSE.md)).
