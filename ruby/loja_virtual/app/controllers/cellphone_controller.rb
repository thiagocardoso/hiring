require 'roo'

class CellphoneController < ApplicationController
  def index
  	@cellphones = Cellphone.all
  end

  def create
  	build_and_save(cellphone_params)

  	redirect_to cellphone_index_url
  end

  def import
  	flash[:errors] = []
  	parsed = Roo::CSV.new(params.require(:file)).parse(headers: true)

  	parsed.shift #remove header line

  	parsed.each_with_index do |row, index|
  	  build_and_save(row, index)
  	end
  end

  private
    def cellphone_params
	  params.require(:cellphone).permit(:manufacturer, :model, :color, :carrier_plan_type, :quantity, :price)
    end

    def build_and_save params, row_no = 0
      cellphone = Cellphone.new(params)

      unless cellphone.save
      	flash[:errors].push("Error at row number: #{row_no}: #{cellphone.errors.full_messages.join(', ')}") 
      end
    end
end
