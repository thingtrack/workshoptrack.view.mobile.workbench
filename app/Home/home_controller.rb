require 'rho/rhocontroller'
require 'helpers/browser_helper'

class HomeController < Rho::RhoController
  include BrowserHelper

  # GET /Home
  def index
      render :action => :index    
  end
  
end
