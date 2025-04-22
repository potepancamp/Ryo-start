require 'rails_helper'

RSpec.describe "ProductsController", type: :request do
  include AncestorsHelper
  shared_examples "パンくずリストの表示内容" do
    it "ホームが含まれていること" do
      expect(response.body).to include("ホーム")
    end

    it "祖先カテゴリ名がすべて含まれていること" do
      get_ancestors(taxon).each do |ancestor|
        expect(response.body).to include(ancestor.name)
      end
    end

    it "商品カテゴリ（直接紐付いたカテゴリ）が含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "商品名がパンくずリストに含まれていること" do
      expect(response.body).to include(product.name)
    end
  end

  shared_examples "共通レスポンスチェック" do
    it "が200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.price.to_s)
    end
  end

  # -----------------------------------
  context "【3階層構成】Clothing → Hoodie → Ruby Hoodie Zip" do
    let(:grandparent_taxon) { create(:taxon, name: "Clothing") }
    let(:parent_taxon) { create(:taxon, name: "Hoodie", parent: grandparent_taxon) }
    let(:taxon) { create(:taxon, name: "Ruby Hoodie Zip", parent: parent_taxon) }
    let(:product) { create(:product, name: "Ruby Hoodie Zip", taxons: [taxon]) }

    before { get product_path(product.id) }

    include_examples "共通レスポンスチェック"
    include_examples "パンくずリストの表示内容"
  end

  # -----------------------------------
  context "【2階層構成】Caps → Solidus Snapback Cap" do
    let(:parent_taxon) { create(:taxon, name: "Caps") }
    let(:taxon) { parent_taxon }  # taxonにparent_taxonを代入（child_taxonなし）
    let(:product) { create(:product, name: "Solidus Snapback Cap", taxons: [taxon]) }

    before { get product_path(product.id) }

    include_examples "共通レスポンスチェック"
    include_examples "パンくずリストの表示内容"
  end
end
