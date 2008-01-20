require File.join(MIGRATOR_ROOT, 'environment')

class Trackback < ActiveRecord::Base
  belongs_to :article
end