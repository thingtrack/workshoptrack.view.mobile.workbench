module BrowserHelper

  def placeholder(label=nil)
    "placeholder='#{label}'" if platform == 'apple'
  end

  def platform
    System::get_property('platform').downcase
  end

  def selected(option_value,object_value)
    "selected=\"yes\"" if option_value == object_value
  end

  def checked(option_value,object_value)
    "checked=\"yes\"" if option_value == object_value
  end

  def is_bb6
    platform == 'blackberry' && (System::get_property('os_version').split('.')[0].to_i >= 6)
  end
  
  # WORKSHOPTRACK HELPER METHODS
  
  def product(product_id)
    response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/products/#{product_id}"
    })
   
    product =  Rho::JSON.parse(response["body"].to_s)
    product if product
  end
  
  def container_type(type_id)
    container_type = ContainerType.find(:first, :conditions => {:id => type_id} )
    container_type.description if container_type        
  end
   
  def container_status(status_id)
    container_status = ContainerStatus.find(:first, :conditions => {:id => status_id  })
    container_status.description if container_status
  end
  
  def stock_status(stock_status_id)
    stock_status = StockStatus.find(:first, :conditions => {:id => stock_status_id} )
    stock_status if stock_status
  end
  
  def stock_statuses
    StockStatus.find(:all)
  end
  
  def product_package(product_id, product_package_id)
    
    # GET container
    response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/products/#{product_id}/packages/#{product_package_id}"
    })
   
    product_package =  Rho::JSON.parse(response["body"].to_s)
    product_package if product_package 
  end
  
  def product_packages(product_id)
    
    # GET container
    response = Rho::Network.get({
       :url => "http://localhost:8080/workshoptrack.service.rest/products/#{product_id}/packages"
    })
   
    product_packages =  Rho::JSON.parse(response["body"].to_s)
    product_packages if product_packages   
  end
  
  def retrieve_product_unit(product_unit_id)
    product_unit = ProductUnit.find(:first, :conditions => {:id => product_unit_id })
    product_unit if product_unit
  end
  
end