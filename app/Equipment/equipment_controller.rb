require 'rho/rhocontroller'
require 'helpers/browser_helper'

class EquipmentController < Rho::RhoController
  include BrowserHelper

  # GET /Equipment
  def index
    @equipment = Equipment.find(:all)
    render :back => '/app'
  end

  # GET /Equipment/{1}
  def show
    @equipment = Equipment.find(@params['id'])
    if @equipment
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Equipment/new
  def new
    @equipment = Equipment.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Equipment/{1}/edit
  def edit
    @equipment = Equipment.find(@params['id'])
    if @equipment
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Equipment/create
  def create
    @equipment = Equipment.create(@params['equipment'])
    redirect :action => :index
  end

  # POST /Equipment/{1}/update
  def update
    @equipment = Equipment.find(@params['id'])
    @equipment.update_attributes(@params['equipment']) if @equipment
    redirect :action => :index
  end

  # POST /Equipment/{1}/delete
  def delete
    @equipment = Equipment.find(@params['id'])
    @equipment.destroy if @equipment
    redirect :action => :index  
  end
end
