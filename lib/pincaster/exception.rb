module Pincaster
  class Pincaster::Exception < Exception
  end
end

class Pincaster::NoSuchLayer       < Pincaster::Exception; end
class Pincaster::LayerAlreadyExist < Pincaster::Exception; end
class Pincaster::LayerError        < Pincaster::Exception; end
class Pincaster::NoServer          < Pincaster::Exception; end
