$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Pincaster
  VERSION = '0.1'

  autoload :Exception, 'pincaster/exception'
  autoload :Server,    'pincaster/server'
  autoload :Layer,     'pincaster/layer'
end
