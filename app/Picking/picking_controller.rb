require 'rho/rhocontroller'
require 'helpers/browser_helper'

class PickingController < Rho::RhoController
  include BrowserHelper

  # GET /Picking
  def index
    @pickings = Picking.find(:all)
    render :back => '/app'
  end

  # GET /Picking/{1}
  def show
    @picking = Picking.find(@params['id'])
    if @picking
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Picking/new
  def new
    @picking = Picking.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Picking/{1}/edit
  def edit
    @picking = Picking.find(@params['id'])
    if @picking
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Picking/create
  def create
    @picking = Picking.create(@params['picking'])
    redirect :action => :index
  end

  # POST /Picking/{1}/update
  def update
    @picking = Picking.find(@params['id'])
    @picking.update_attributes(@params['picking']) if @picking
    redirect :action => :index
  end

  # POST /Picking/{1}/delete
  def delete
    @picking = Picking.find(@params['id'])
    @picking.destroy if @picking
    redirect :action => :index  
  end
end
