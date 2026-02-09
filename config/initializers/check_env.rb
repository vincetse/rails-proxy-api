# This will raise a KeyError and stop the server from starting
# if UPSTREAM_URL is not set.
begin
  ENV.fetch("UPSTREAM_URL")
rescue KeyError
  puts "\n" + ("!" * 60)
  puts " CRITICAL ERROR: UPSTREAM_URL environment variable is missing."
  puts " The proxy cannot function without a target back-end URL."
  puts ("!" * 60) + "\n"

  # Exit the process immediately
  exit 1
end
