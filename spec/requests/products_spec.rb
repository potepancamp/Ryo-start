require 'rails_helper'

RSpec.describe "Products Show Page", type: :request do
  let!(:product) { create(:product) }
  
  describe "GET /products/:id" do
    before do
      get product_path(product.id)
    end

    it "returns a successful response" do
      expect(response).to have_http_status(200)
    end

    it "displays the product name" do
      expect(response.body).to include(product.name)
    end

    it "displays the product price" do
      expect(response.body).to include(product.price.to_s)
    end
  end
end
