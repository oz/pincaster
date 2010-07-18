module Pincaster
  class Pincaster::Exception < Exception
  end
end

class Pincaster::LayerNotFound     < Pincaster::Exception; end
class Pincaster::LayerAlreadyExist < Pincaster::Exception; end
class Pincaster::LayerError        < Pincaster::Exception; end
class Pincaster::NoServer          < Pincaster::Exception; end
