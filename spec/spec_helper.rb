$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'pincaster'
require 'spec'
#require 'spec/autorun'
require 'fileutils'

Spec::Runner.configure do |config|
  config.before :suite do
    @@pincaster_db        = '/tmp/pincaster_spec.db'
    @@pincaster_conf_file = '/tmp/pincaster_spec.conf'
    @@pincaster_server_port = 4270

    cleanup_pincaster_files @@pincaster_db, @@pincaster_conf_file
    setup_pincaster_config  @@pincaster_db, @@pincaster_conf_file, @@pincaster_server_port
    @@pincaster_pid = startup_pincaster_daemon @@pincaster_conf_file
    sleep 1  # wait a sec. to be sure your slow machine starts the process...
  end

  config.after :suite do
    Process.kill 'TERM', @@pincaster_pid
    Process.waitpid @@pincaster_pid
    cleanup_pincaster_files @@pincaster_db, @@pincaster_conf_file
  end
end

# Cleanup Pincaster config and db file
def cleanup_pincaster_files(*args)
  args.each do |file|
    File.delete(file) if File.exist? file
  end
end

# Write pincaster config file for rspec
def setup_pincaster_config(db, config, port=4270)
  open config, 'w' do |conf_fh|
    conf_fh << %Q(
      Workers       2
      DBFileName    #{db}
      ServerIP      127.0.0.1
      ServerPort    #{port}
      Daemonize     no
    )
  end
end

# Startup Pincaster daemon with an rspec config
def startup_pincaster_daemon(config)
  Process.fork do
    process = IO.popen "pincaster \"#{config}\" 2>&1"
    trap("TERM") do
      Process.kill "TERM", process.pid
      Process.waitall
    end
  end
end

# Get an rspec-configured Pincaster::Server instance
def pincaster_server_instance
  Pincaster::Server.new :host => '127.0.0.1', :port => @@pincaster_server_port
end

