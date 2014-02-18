require 'rho'
require 'rho/rhocontroller'
require 'rho/rhoerror'
require 'helpers/browser_helper'

class SettingsController < Rho::RhoController
  include BrowserHelper
  
  def index
    @msg = @params['msg']
    render
  end

  def login
    @msg = @params['msg']
    render :action => :login
  end

  def do_login
      if @params['login'] and @params['password']
        
        login_json = { 'username' => @params['login'], 'password' => @params['password'] }.to_json
  
        Rho::Network.post({
                :url => "http://localhost:8080/workshoptrack.service.rest/securityService",
                :headers => {"Content-Type"=>"application/json"},
                :body => login_json                
            }, url_for(:action => :login_callback), 
            "username=#{@params['login']}")
            
          @response['headers']['Wait-Page'] = 'true'
          render :action => :wait
      end
  end
    
  def login_callback
    errCode = @params['error_code'].to_i
    if errCode == 0
      
      # Synchronous request of the logged user, organizations, locations and areas he belongs to
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/securityService/#{@params['username']}"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      current_user =  Rho::JSON.parse( response["body"].to_s)
      
      # Current User
      user = CurrentUser.create(
              :username => current_user['username'], 
              :active_organization => current_user['active_organization'],
              :active_location => current_user['active_location'],
              :active_area => current_user['active_area'])
                
      # Organizations
      current_user['organizations'].each do |organization|
        Organization.create(
          :id => organization['id'],
          :name =>  organization['name'],
          :user_id => current_user['id'].to_s
        ) 
      end
      
      # Locations
      current_user['organizations'].each do |organization|
        organization['locations'].each do |location|
          Location.create(
            :id => location['id'],
            :name => location['name'],
            :organization_id =>  organization['id'].to_s
          )          
        end
      end  
      
      # Areas        
      current_user['organizations'].each do |organization|
        organization['locations'].each do |location|
          location['areas'].each do |area|
            Area.create(
              :id => area['id'],
              :name => area['name'],
              :location_id => location['id'].to_s 
            )            
          end
        end
      end
      
     # Aisle types
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/aisles/types"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      aisle_types =  Rho::JSON.parse(response["body"].to_s)
      
      aisle_types.each do |aisle_type|
            AisleType.create(aisle_type)
      end if aisle_types
      
      
      # Aisle by active area
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
      
      # Bin Status
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/bins/statuses"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      bin_statuses = Rho::JSON.parse(response["body"].to_s)
        
      bin_statuses.each do |bin_status|
        BinStatus.create(bin_status)
      end if bin_statuses
      
      
      # Bin types
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/bins/types"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      bin_types = Rho::JSON.parse(response["body"].to_s)
        
      bin_types.each do |bin_type|
        BinType.create(bin_type)
      end if bin_types
      
      # Shelf statuses
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/shelfs/statuses"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
            
      shelf_statuses = Rho::JSON.parse(response["body"].to_s)
      
      shelf_statuses.each do |shelf_status|
        ShelfStatus.create(shelf_status)
      end if shelf_statuses  
          
      
      # Shelf types
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/shelfs/types"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      shelf_types = Rho::JSON.parse(response["body"].to_s)
      
      shelf_types.each do |shelf_type|
           ShelfType.create(shelf_type)
      end if shelf_types 
      
      
      # Container types
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/containers/types"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      container_types = Rho::JSON.parse(response["body"].to_s)
        
      container_types.each do |container_type|
        ContainerType.create(container_type)
      end if container_types   

      # Container statuses
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/containers/statuses"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      container_statuses = Rho::JSON.parse(response["body"].to_s)
        
      container_statuses.each do |container_status|
          ContainerStatus.create(container_status)
      end if container_statuses
      
      # Stock statuses
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/stocks/statuses"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      stock_statuses = Rho::JSON.parse(response["body"].to_s)
      
      stock_statuses.each do |stock_status|
        StockStatus.create(stock_status)
      end if stock_statuses  
     
      
      # Product units
      response = Rho::Network.get({
          :url => "http://localhost:8080/workshoptrack.service.rest/products/units"
      })
      
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
      
      product_units = Rho::JSON.parse(response["body"].to_s)
        
      product_units.each do |product_unit|
          ProductUnit.create(product_unit)      
      end if product_units
        
      WebView.navigate ( url_for :controller => :Home )
      
    else
      if errCode == Rho::RhoError::ERR_CUSTOMSYNCSERVER
        @msg = @params['error_message']
      end
        
      if !@msg || @msg.length == 0   
        @msg = Rho::RhoError.new(errCode).message
      end
      
      WebView.navigate ( url_for :action => :login, :query => {:msg => @msg} )
    end  
  end
  
  def logout
    SyncEngine.logout
    SyncEngine.set_notification(CurrentUser.get_source_id, "/app/Settings/sync_notify", "")
    @msg = "You have been logged out."
    render :action => :login
  end
  
  def reset
    render :action => :reset
  end
  
  def do_reset
    Rhom::Rhom.database_full_reset
    SyncEngine.dosync
    @msg = "Database has been reset."
    redirect :action => :index, :query => {:msg => @msg}
  end
  
  def do_sync
    SyncEngine.dosync
    @msg =  "Sync has been triggered."
    redirect :action => :index, :query => {:msg => @msg}
  end
  
  def sync_notify
  	status = @params['status'] ? @params['status'] : ""
  	
  	# un-comment to show a debug status pop-up
  	Alert.show_status( "Status", "#{@params['source_name']} : #{status}", Rho::RhoMessages.get_message('hide'))
  	
  	if status == "in_progress" 	
  	  # do nothing
  	  puts " In progress!"
  	elsif status == "ok"
  	  
      SyncEngine.clear_notification(@params["source_id"].to_i)
  	  if @params["source_name"] == CurrentUser.get_source_name
        
  	    # Synchronize user's models
  	    current_user = CurrentUser.find(:all, :conditions => { :username => SyncEngine.get_user_name})
        SyncEngine.dosync_source(Aisle.get_source_name, false,'area_id=#{current_user.active_area}')
  	    SyncEngine.dosync_source(Shelf.get_source_name, false,'area_id=#{current_user.active_area}')
        
  	    WebView.navigate "/app/Home" if @params['sync_type'] != 'bulk'
  	  end
      
  	elsif status == "error"
	
      if @params['server_errors'] && @params['server_errors']['create-error']
        SyncEngine.on_sync_create_error( 
          @params['source_name'], @params['server_errors']['create-error'].keys, :delete )
      end

      if @params['server_errors'] && @params['server_errors']['update-error']
        SyncEngine.on_sync_update_error(
          @params['source_name'], @params['server_errors']['update-error'], :retry )
      end
      
      err_code = @params['error_code'].to_i
      rho_error = Rho::RhoError.new(err_code)
      
      @msg = @params['error_message'] if err_code == Rho::RhoError::ERR_CUSTOMSYNCSERVER
      @msg = rho_error.message unless @msg && @msg.length > 0   

      if rho_error.unknown_client?( @params['error_message'] )
        Rhom::Rhom.database_client_reset
        SyncEngine.dosync
      elsif err_code == Rho::RhoError::ERR_UNATHORIZED
        WebView.navigate( 
          url_for :action => :login, 
          :query => {:msg => "Server credentials are expired"} )                
      elsif err_code != Rho::RhoError::ERR_CUSTOMSYNCSERVER
        WebView.navigate( url_for :action => :err_sync, :query => { :msg => @msg } )
      end    
      end
  end 
  
  def on_sync_user_changed
    super
    Rhom::Rhom.database_local_reset
  end 
end
