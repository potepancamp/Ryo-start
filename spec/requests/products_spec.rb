require 'rails_helper'

RSpec.describe "Products Show Page", type: :request do
  let(:product) do
    taxonomy = create(:taxonomy)
    parent_taxon = create(:taxon, name: "親カテゴリ", taxonomy: taxonomy)
    child_taxon = create(:taxon, name: "子カテゴリ", taxonomy: taxonomy, parent: parent_taxon)

    product = create(:product)
    product.taxons << child_taxon

    product
  end

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
      expect(response.body).to include("親カテゴリ")
      expect(response.body).to include("子カテゴリ")
    end
  end
end
