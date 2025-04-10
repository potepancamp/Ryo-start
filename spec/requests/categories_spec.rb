require 'rails_helper'

RSpec.describe "CategoriesController", type: :request do
  describe "GET #show" do
    let(:taxon) { create(:taxon) }
    let(:product) { create(:product, taxons: [taxon]) }

    before do
      get category_path(taxon.id)
    end

    it "ステータスの確認" do
      expect(response).to have_http_status(200)
    end

    it "商品名がレスポンスに含まれていること" do
      expect(response.body).to include(taxon.name)
      taxon.products.includes(variants: [:prices, { images: :attachment_blob }]).each do |product|
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.display_price.to_s)
      end
    end
  end
end
