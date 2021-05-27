class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
  attribute :revenue do |object|
    object.total_revenue
  end
end
