require 'rho/rhocontroller'
require 'helpers/browser_helper'

class ConsolidationController < Rho::RhoController
  include BrowserHelper

  # GET /Consolidation
  def index
    @consolidations = Consolidation.find(:all)
    render :back => '/app'
  end

  # GET /Consolidation/{1}
  def show
    @consolidation = Consolidation.find(@params['id'])
    if @consolidation
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Consolidation/new
  def new
    @consolidation = Consolidation.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Consolidation/{1}/edit
  def edit
    @consolidation = Consolidation.find(@params['id'])
    if @consolidation
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Consolidation/create
  def create
    @consolidation = Consolidation.create(@params['consolidation'])
    redirect :action => :index
  end

  # POST /Consolidation/{1}/update
  def update
    @consolidation = Consolidation.find(@params['id'])
    @consolidation.update_attributes(@params['consolidation']) if @consolidation
    redirect :action => :index
  end

  # POST /Consolidation/{1}/delete
  def delete
    @consolidation = Consolidation.find(@params['id'])
    @consolidation.destroy if @consolidation
    redirect :action => :index  
  end
end
