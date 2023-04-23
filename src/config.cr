require "yaml"

record ScheduledTime, days : UInt32 = 0, hours : UInt32 = 0, minutes : UInt32 = 0, seconds : UInt32 = 0, nanoseconds : UInt32 = 0 do
  include YAML::Serializable
end

record Job, link : String, every : ScheduledTime do
  include YAML::Serializable

  @[YAML::Field(ignore: true)]
  getter scheduled_span : Time::Span do
    Time::Span.new days: every.days, hours: every.hours, minutes: every.minutes,
      seconds: every.seconds, nanoseconds: every.nanoseconds
  end
end

record Config, jobs : Array(Job) do
  include YAML::Serializable

  INSTANCE = File.open ENV.fetch "CONFIG", "/etc/webcron/config.yml" do |file|
    Config.from_yaml file
  end

  def self.jobs
    INSTANCE.jobs
  end
end
