task :default => :start

def screen command
  sh "screen -S eircd -X stuff '#{command}\n'"
end

task :build do
  sh "sinan build"
end

task :start => :build do
  screen 'erl'
  screen 'application:start(eircd).'
end

task :stop do
  screen 'application:stop(eircd).'
  screen 'q().'
end