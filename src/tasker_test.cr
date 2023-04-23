require "tasker"

one = Tasker.every 1.second do
  "one #{Time.local.to_rfc3339}"
end

two = Tasker.every 2.seconds do
  "two #{Time.local.to_rfc3339}"
end

spawn do
  one.each &->puts(String)
end

spawn do
  two.each &->puts(String)
end

sleep
