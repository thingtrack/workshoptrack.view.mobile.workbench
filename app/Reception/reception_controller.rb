require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ReceptionController < Rho::RhoController
  include BrowserHelper

  # GET /Reception
  def index
    @receptions = Reception.find(:all)
    render :back => '/app'
  end

  # GET /Reception/{1}
  def show
    @reception = Reception.find(@params['id'])
    if @reception
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Reception/new
  def new
    @reception = Reception.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Reception/{1}/edit
  def edit
    @reception = Reception.find(@params['id'])
    if @reception
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Reception/create
  def create
    @reception = Reception.create(@params['reception'])
    redirect :action => :index
  end

  # POST /Reception/{1}/update
  def update
    @reception = Reception.find(@params['id'])
    @reception.update_attributes(@params['reception']) if @reception
    redirect :action => :index
  end

  # POST /Reception/{1}/delete
  def delete
    @reception = Reception.find(@params['id'])
    @reception.destroy if @reception
    redirect :action => :index  
  end
end
