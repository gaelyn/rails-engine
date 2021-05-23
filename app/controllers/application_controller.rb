class ApplicationController < ActionController::API
  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def page
    page = [params.fetch(:page, 1).to_i, 1].max
    (page - 1) * per_page
  end
end
