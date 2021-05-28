class ApplicationController < ActionController::API
  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def page
    page = [params.fetch(:page, 1).to_i, 1].max
    (page - 1) * per_page
  end

  def no_merchant_error
    render :json => {:error =>  "Record Not Found"}.to_json, :status => 404 if !Merchant.find(@item.merchant_id)
  end

  def unprocessable_entity
    render :json => {:error =>  "Unprocessable Entity"}.to_json, :status => 422
  end
end
