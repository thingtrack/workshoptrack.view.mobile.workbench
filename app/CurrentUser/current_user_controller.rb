require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class CurrentUserController < Rho::RhoController
  include BrowserHelper
  # GET /CurrentUser
  def index
    @current_user = CurrentUser.find(:first)
    @organizations = Organization.find(:all)
    @locations =  Location.find(:all, :conditions => {:organization_id => @current_user.active_organization})
    @areas = Area.find(:all, :conditions => { :location_id => @current_user.active_location})
    render :action => :index, :back => url_for(:controller => :Home, :action => :index)
  end

  def getLocations
    organization_id = @params['organization_selected']
    locations = Location.find(:all, :conditions => {:organization_id => organization_id})
    WebView.execute_js("fillLocations('" + locations.to_json + "');")
  end

  def getAreas
    location_id = @params['location_selected']
    areas = Area.find(:all, :conditions => {:location_id => location_id})
    WebView.execute_js("fillAreas('" + areas.to_json + "');")
    
  end

  def apply
    @currentuser = CurrentUser.find(@params['id'])
    @currentuser.update_attributes(@params['current_user']) if @currentuser
    
    # Update aisle list
    Aisle.deleteAll();
    
    response = Rho::Network.get({
        :url => "http://localhost:8080/workshoptrack.service.rest/aisles/area/#{current_user['active_area']}"
    })
    
    if response["status"] != "ok"
        puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end
    
    aisles =  Rho::JSON.parse(response["body"].to_s)
    
    aisles.each do |aisle|
          Aisle.create(aisle)
    end if aisles
    
    redirect :controller => :Home, :action => :index
  end

end
