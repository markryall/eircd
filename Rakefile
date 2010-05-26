require 'socket'

task :default => :features

module Eircd
  def start_eircd
    screen 'erl'
    screen 'application:start(eircd).'
  end
  
  def stop_eircd
    screen 'application:stop(eircd).'
    screen 'q().'
  end

  def verify_eircd timeout
    sleep 1
  end
private
  def screen command
    sh "screen -S eircd -X stuff '#{command}\n'"
  end
end

include Eircd

task :build do
  sh "sinan build"
end

task :features => :start do
  begin
    verify_eircd 1000
    sh "cucumber"
  ensure
    stop_eircd
  end
end

task :start => :build do
  start_eircd
end

task :stop do
  stop_eircd
end