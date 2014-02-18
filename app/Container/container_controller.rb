require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'


class ContainerController < Rho::RhoController
  include BrowserHelper

  # GET /Container
  def index
      render :action => :index
  end
    
  # GET /Container/new
  def new
    @bin = @params['bin']
    
    @container_statuses = ContainerStatus.find(:all)
    @container_types = ContainerType.find(:all)
    
    render :action => :new, :back => url_for(:action => :index)
  end
  
  # GET /Container/create
  def create
    Rho::Network.post({
          :url => "http://localhost:8080/workshoptrack.service.rest/containers",
          :headers => {"Content-Type"=>"application/json"},
          :body => @params['container'].to_json       
        })

    redirect :controller => :Bin, :action => :show, :query => { :id => @params['container']['bin_id']}
  end
  
  #GET Container/{1}/show
  def show
    
    currentUser = CurrentUser.find(:first)
    
    # GET container
    response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{currentUser.active_area}/#{@params['number']}"
    })
   
    if response["status"] != "ok"
        puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end
     
    @container =  Rho::JSON.parse(response["body"].to_s)
   
    # GET stocks
    response = Rho::Network.get({
        :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{@container['id']}/stocks"
    })
   
    if response["status"] != "ok"
        puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end
     
    @stocks =  Rho::JSON.parse(response["body"].to_s)
    
    #GET bin 
    response = Rho::Network.get({
        :url => "http://localhost:8080/workshoptrack.service.rest/bins/#{@container['bin_id']}"
    })
   
    if response["status"] != "ok"
        puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end
     
    @bin =  Rho::JSON.parse(response["body"].to_s)
    
    # Check where comes from the navigation 
    if @params['bin']
      @bin_search_path = true;
    else @bin_search_path = false;
    end
      
    render :action => :show  
  end
  
  # POST /Container/{1}/delete
   def delete
     @bin = @params['bin']
       
     response = Rho::Network.post({
       :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{@params['id']}",
       :httpVerb => "DELETE"                 
     })
 
     if response["status"] != "ok"
            puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
     end
         
     redirect :controller=> :Bin, :action => :refresh, :query => { :id => @bin }
   end
   
   #GET /Container/search
   def search
     
     currentUser = CurrentUser.find(:first)
     
     response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{currentUser.active_area}/#{@params['number']}"      
     })
     
     if response["status"] == "ok"
      container = Rho::JSON.parse(response["body"].to_s)
        
      # GET bin
      response = Rho::Network.get({
         :url => "http://localhost:8080/workshoptrack.service.rest/bins/#{container['bin_id']}"      
      })
       
      bin = Rho::JSON.parse(response["body"].to_s)
        
      # GET AISLE
      response = Rho::Network.get({
         :url => "http://localhost:8080/workshoptrack.service.rest/aisles/#{bin['aisle_id']}"      
      })
            
      aisle = Rho::JSON.parse(response["body"].to_s)
             
      # GET stocks
      response = Rho::Network.get({
         :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{container['id']}/stocks"
      })
     
      if response["status"] != "ok"
          puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
      end
       
      stocks =  Rho::JSON.parse(response["body"].to_s)  
      container['stock_lines'] = stocks.length
      container['bin'] = bin['label']
      container['aisle'] = aisle['code']
        
      render :string => container.to_json, :use_layout_on_ajax => true
      else
       container = {}
       render :string => container.to_json, :use_layout_on_ajax => true
     end
       
       
        end

end
