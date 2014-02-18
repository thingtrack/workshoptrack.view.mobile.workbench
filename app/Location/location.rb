# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Location
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Location.
   enable :sync

  #add model specific code here
  belongs_to :organization_id, 'Organization'
end
