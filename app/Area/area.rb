# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Area
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Area.
   enable :sync

  #add model specific code here
  belongs_to :location_id, 'Location'
end
