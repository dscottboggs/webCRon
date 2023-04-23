require "tasker"
require "http"
require "json"
require "./config"

done = Channel(Nil).new

tasks = Config.jobs.map do |job|
  task = Tasker.every job.scheduled_span do
    start = Time.utc
    timer = Time.monotonic
    begin
      response = HTTP::Client.get job.link
      {
        time: {
          start:    start.to_rfc2822,
          end:      Time.utc.to_rfc2822,
          duration: (Time.monotonic - timer).to_s,
        },
        status: {
          code:    response.status_code,
          message: response.status_message,
        },
        body: response.body?,
      }
    rescue err
      {time: {
        start:    start.to_rfc2822,
        end:      Time.utc.to_rfc2822,
        duration: (Time.monotonic - timer).to_s,
      },
       error: {
         message:   err.message,
         backtrace: err.backtrace?,
       },
      }
    end
  end
end

# Signal::INT.trap do
#   tasks.each &.cancel
#   done.send nil
# end

tasks.each do |task|
  task.each do |result|
    result.to_json STDOUT
    puts
  end
end

# done.receive
sleep
