require 'rho/rhocontroller'
require 'helpers/browser_helper'

class PrinterController < Rho::RhoController
  include BrowserHelper

  # GET /Printer
  def index
    @printers = Printer.find(:all)
    render :back => '/app'
  end

  # GET /Printer/{1}
  def show
    @printer = Printer.find(@params['id'])
    if @printer
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Printer/new
  def new
    @printer = Printer.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Printer/{1}/edit
  def edit
    @printer = Printer.find(@params['id'])
    if @printer
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Printer/create
  def create
    @printer = Printer.create(@params['printer'])
    redirect :action => :index
  end

  # POST /Printer/{1}/update
  def update
    @printer = Printer.find(@params['id'])
    @printer.update_attributes(@params['printer']) if @printer
    redirect :action => :index
  end

  # POST /Printer/{1}/delete
  def delete
    @printer = Printer.find(@params['id'])
    @printer.destroy if @printer
    redirect :action => :index  
  end
end
