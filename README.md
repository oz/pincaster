Pincaster
=========

Ruby sugar for Pincaster's REST API.

    require 'pincaster'
    
    # List layers
    server = Pincaster::Server.new :host => 'localhost', :port => 4269
    p server.layers
    
    # Create a new layer
    layer = Pincaster::Layer.new :name => "foo", :server => server
    layer.save
    p layer
    layer.destroy

Note on Patches/Pull Requests
=============================
 
  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a
    future version unintentionally.
  * Commit, do not mess with rakefile, version, or history.
    (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
  * Send me a pull request. Bonus points for topic branches.

Copyright
=========

Copyright (c) 2010 Arnaud Berthomier. See LICENSE for details.
