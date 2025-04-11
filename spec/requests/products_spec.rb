require 'rails_helper'

RSpec.describe "Products Show Page", type: :request do
  let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
  let(:child_taxon) { create(:taxon, name: "子カテゴリ", parent: parent_taxon) }
  let(:product) { create(:product, taxons: [child_taxon]) }

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

    it "displays breadcrumbs with correct category names" do
      expect(response.body).to include("ホーム")
      expect(response.body).to include(parent_taxon.name)
      expect(response.body).to include(child_taxon.name)
    end
  end
end
