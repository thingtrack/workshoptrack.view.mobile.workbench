require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ExpeditionController < Rho::RhoController
  include BrowserHelper

  # GET /Expedition
  def index
    @expeditions = Expedition.find(:all)
    render :back => '/app'
  end

  # GET /Expedition/{1}
  def show
    @expedition = Expedition.find(@params['id'])
    if @expedition
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Expedition/new
  def new
    @expedition = Expedition.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Expedition/{1}/edit
  def edit
    @expedition = Expedition.find(@params['id'])
    if @expedition
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Expedition/create
  def create
    @expedition = Expedition.create(@params['expedition'])
    redirect :action => :index
  end

  # POST /Expedition/{1}/update
  def update
    @expedition = Expedition.find(@params['id'])
    @expedition.update_attributes(@params['expedition']) if @expedition
    redirect :action => :index
  end

  # POST /Expedition/{1}/delete
  def delete
    @expedition = Expedition.find(@params['id'])
    @expedition.destroy if @expedition
    redirect :action => :index  
  end
end
