# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Organization
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Organization.
   enable :sync

  #add model specific code here
  belongs_to :user_id, 'CurrentUser'
end
