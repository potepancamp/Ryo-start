require 'rails_helper'
require Rails.root.join("app/models/product_decorator.rb")

RSpec.describe Spree::Product, type: :model do
  let(:ancestor) { create(:taxon, name: "親カテゴリー") }
  let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
  let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
  let!(:related_product) { create(:product, taxons: [taxon]) }
  let!(:unrelated_product) { create(:product) }

  describe "related_products" do
    it "自分自身を含まないこと" do
      expect(product.related_products).not_to include(product)
    end

    it "同じカテゴリに属する他の商品を含むこと" do
      expect(product.related_products).to match_array([related_product])
    end
    
    it "異なるカテゴリの商品は含まないこと" do
      expect(product.related_products).not_to include(unrelated_product)
    end

    it "重複を含まないこと" do
      # テストデータに基づいて重複を確認
      related_product_ids = product.related_products.map(&:id)
      expect(related_product_ids.uniq.size).to eq(related_product_ids.size)
    end
  end
end


# 「重複条件を持つテストデータ」を明示的に作り、期待値と照らし合わせるテスト
# であるべきです。
