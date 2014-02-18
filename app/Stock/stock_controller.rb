require 'rho/rhocontroller'
require 'helpers/browser_helper'
require 'json'

class StockController < Rho::RhoController
  include BrowserHelper
   
  
  # GET /Stock/index
  def index 
    if @params['bin']
      redirect :controller => :Container, :action => :show, :id => @params['stock']['container_id'], :query => { :bin => @params['bin'] }
    else
      redirect :controller => :Container, :action => :show, :id => @params['stock']['container_id'] 
    end  
  end

  # GET /Stock/add_stock
  def add_stock
    # GET the bin
    if @params['bin']
      response = Rho::Network.get({
         :url => "http://localhost:8080/workshoptrack.service.rest/bins/#{@params['bin']}"
      })
     
      if response["status"] == "ok"
        @bin =  Rho::JSON.parse(response["body"].to_s)  
      end
    end
   #GET the container
     currentUser = CurrentUser.find(:first)
     
     response = Rho::Network.get({
        :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{currentUser.active_area}/#{@params['number']}"
     })
    
     if response["status"] != "ok"
         puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
     end
      
     @container =  Rho::JSON.parse(response["body"].to_s)
     
    # GET stocks
    response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{@params['container']}/stocks"
    })
   
    if response["status"] != "ok"
        puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end
     
    @stocks =  Rho::JSON.parse(response["body"].to_s)
    
    # Check product logistic policy
    if !is_empty?(@stocks) && !is_multiref?(@stocks) && !is_mixed?(@stocks)
      @product =  get_default_product(@stocks)
      
      product_packages = product_packages(@product['id'])
      if product_packages && product_packages.length == 1
        @product['product_package_id'] = product_packages[0]['id']
        @product['product_unit_id'] = product_packages[0]['product_unit_id'] 
        @product_flag = true 
      end
    end
    
     render :action => :add_stock
  end
  
  # GET /Stock/remove_stock
  def remove_stock
    
    # GET the bin
    if @params['bin']
      response = Rho::Network.get({
         :url => "http://localhost:8080/workshoptrack.service.rest/bins/#{@params['bin']}"
      })
     
      if response["status"] == "ok"
        @bin =  Rho::JSON.parse(response["body"].to_s)  
      end
    end
   #GET the container
   currentUser = CurrentUser.find(:first)
    
   response = Rho::Network.get({
      :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{currentUser.active_area}/#{@params['number']}"
   })
    
   if response["status"] != "ok"
       puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
   end
      
   @container =  Rho::JSON.parse(response["body"].to_s)
     
   # GET stocks
   response = Rho::Network.get({
      :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{@params['container']}/stocks"
   })
   
   if response["status"] != "ok"
      puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
   end
     
   @stocks =  Rho::JSON.parse(response["body"].to_s)
  
   # Check product logistic policy
   if !is_empty?(@stocks) && !is_multiref?(@stocks) && !is_mixed?(@stocks)
     @product =  get_default_product(@stocks)
    
     product_packages = product_packages(@product['id'])
     if product_packages && product_packages.length == 1
        @product['product_package_id'] = product_packages[0]['id']
        @product['product_unit_id'] = product_packages[0]['product_unit_id'] 
        @product_flag = true 
     end
   end
    
   render :action => :remove_stock
  end

  def is_empty?(stocks)
    return stocks.length == 0 if stocks
  end
  
  def is_multiref?(stocks)
    product_code = nil
    stocks.each do |stock|
      product = product(stock['product_id'])
      if product_code != product['code']
        return true
      end  if product_code
      product_code =  product['code']
    end if stocks
    return false
  end
  
  def is_mixed?(stocks)
    stocks.each do |stock|
      product = product(stock['product_id'])
      if product['mixed'] == true || product['mixed'] =~ (/(true|t|yes|y|1)$/i)
        return true
      end
    end if stocks
    return false
  end
  
  def get_default_product(stocks)
    if stocks
      return product(stocks[0]['product_id'])
    end
  end
  
  # GET /Stock/product_unit/{1}
  def product_unit
    product_unit = ProductUnit.find(:first, :conditions => {:id => @params['id'] } )
    WebView.execute_js("fill_product_unit('" + product_unit.to_json + "');")
  end
  
  # GET /Stock/search
  def search
    
    response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/products/packages/#{@params['label']}"
    })
   
    if response["status"] != "ok"
        puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end
     
    product_package =  Rho::JSON.parse(response["body"].to_s)
    
    if product_package
        product = product(product_package['product_id'])
        product_package['product_code'] = product['code']
        product_package['product_name'] = product['name']
        product_package['product_has_weight'] = product['has_weight']
        product_package['product_has_lote'] = product['has_lote']
        product_package['product_has_expedition_date'] = product['has_expedition_date']
        product_package['product_has_serial_number'] = product['has_serial_number']        
    else
     product_package = {}   
    end
         
    WebView.execute_js("result('"+ product_package.to_json() +"');")
  end
  
  # GET /Stock/create
  def create
    response = Rho::Network.post({
      :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{@params['stock']['container_id']}/stocks",
      :headers => {"Content-Type"=>"application/json"},
      :body => @params['stock'].to_json       
    })

    if response["status"] != "ok"
      puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end

    redirect :controller=> :Container, :action => :show, :query => { :bin => @params['bin'], :number => @params['container_number'] }
  end
  
  # GET /Stock/delete
  def delete
    
    response = Rho::Network.post({
      :url => "http://localhost:8080/workshoptrack.service.rest/containers/#{@params['stock']['container_id']}/stocks",
      :headers => {"Content-Type"=>"application/json"},
      :httpVerb => "DELETE",  
      :body => @params['stock'].to_json       
    })

    if response["status"] != "ok"
      puts "Request complete, the server returned status code #{response["http_error"]} and body #{response["body"]}"
    end

    redirect :controller=> :Container, :action => :show, :query => { :bin => @params['bin'], :number => @params['container_number'] }      
  end
   
end
