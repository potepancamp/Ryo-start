require 'rails_helper'

RSpec.describe "ProductsController", type: :request do
  shared_examples "共通レスポンスチェック" do
    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "ページタイトルが含まれていること" do
      expect(response.body).to include("#{product.name} - BIGBAG Store")
    end

    it "商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.price.to_s)
    end
  end

  shared_examples "パンくずリストの表示内容" do
    it "ホームが含まれていること" do
      expect(response.body).to include("ホーム")
    end
  end

  context "【3階層構成】親カテゴリ → 子カテゴリ → 商品名" do
    let(:grandparent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:parent_taxon) { create(:taxon, name: "子カテゴリ", parent: grandparent_taxon) }
    let(:taxon) { create(:taxon, name: "商品カテゴリ", parent: parent_taxon) }
    let(:product) { create(:product, name: "商品名", taxons: [taxon]) }

    before { get product_path(product.id) }

    include_examples "共通レスポンスチェック"
    include_examples "パンくずリストの表示内容"
  end

  context "【2階層構成】親カテゴリ → 商品名" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:taxon) { parent_taxon } # taxonにparent_taxonを代入（child_taxonなし）
    let(:product) { create(:product, name: "商品名", taxons: [taxon]) }

    before { get product_path(product.id) }

    include_examples "共通レスポンスチェック"
    include_examples "パンくずリストの表示内容"
  end
end
