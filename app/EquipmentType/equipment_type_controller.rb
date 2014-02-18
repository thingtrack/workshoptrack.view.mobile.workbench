require 'rho/rhocontroller'
require 'helpers/browser_helper'

class EquipmentTypeController < Rho::RhoController
  include BrowserHelper

  # GET /EquipmentType
  def index
    @equipmenttypes = EquipmentType.find(:all)
    render :back => '/app'
  end

  # GET /EquipmentType/{1}
  def show
    @equipmenttype = EquipmentType.find(@params['id'])
    if @equipmenttype
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /EquipmentType/new
  def new
    @equipmenttype = EquipmentType.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /EquipmentType/{1}/edit
  def edit
    @equipmenttype = EquipmentType.find(@params['id'])
    if @equipmenttype
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /EquipmentType/create
  def create
    @equipmenttype = EquipmentType.create(@params['equipmenttype'])
    redirect :action => :index
  end

  # POST /EquipmentType/{1}/update
  def update
    @equipmenttype = EquipmentType.find(@params['id'])
    @equipmenttype.update_attributes(@params['equipmenttype']) if @equipmenttype
    redirect :action => :index
  end

  # POST /EquipmentType/{1}/delete
  def delete
    @equipmenttype = EquipmentType.find(@params['id'])
    @equipmenttype.destroy if @equipmenttype
    redirect :action => :index  
  end
end
