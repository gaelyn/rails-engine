class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant_name_revenue
  attributes :name
  attribute :revenue do |object|
    object.total_revenue
  end
end
