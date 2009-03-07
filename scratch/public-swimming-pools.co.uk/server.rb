require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :host => 'localhost',
  :database => 'activeplaces_development',
  :username => 'root'
)

class Site < ActiveRecord::Base
  has_many :facilities
end
class Facility < ActiveRecord::Base
  belongs_to :site
  belongs_to :facility_type
end
class FacilityType < ActiveRecord::Base
end

get '/' do
  if facility_type_slug = params[:facility_type]
    access_type = params[:access_type]
    access_condition = if access_type == 'public'
      "AND public = true"
    elsif access_type == 'private'
      "AND public = false"
    end
    @sites = Site.find(:all, :include => {:facilities => :facility_type }, :conditions => ["latitude IS NOT NULL AND facility_types.slug = ? #{access_condition}", facility_type_slug])
    content_type 'application/xml', :charset => 'utf-8'
    builder :index
  else
    @facility_types = FacilityType.find(:all)
    haml :index
  end
end