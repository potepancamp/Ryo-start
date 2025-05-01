require 'rails_helper'
require Rails.root.join("app/models/potepan/product_decorator.rb")

RSpec.describe Potepan::ProductDecorator, type: :model do
  let(:ancestor) { create(:taxon, name: "親カテゴリー") }
  let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
  let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
  let!(:related_products) { create_list(:product, 4, taxons: [taxon]) }
  let!(:unrelated_product) { create(:product) }

  before do
    Spree::Product.include Potepan::ProductDecorator
  end

  describe "related_products" do
    it "自分自身を含まないこと" do
      expect(product.related_products).not_to include(product)
    end

    it "同じカテゴリに属する他の商品を含むこと" do
      related_products.each do |related_product|
        expect(product.related_products).to include(related_product)
      end
    end

    it "異なるカテゴリの商品は含まないこと" do
      expect(product.related_products).not_to include(unrelated_product)
    end

    it "重複を含まないこと" do
      ids = product.related_products.map(&:id)
      expect(ids.uniq.size).to eq(ids.size)
    end
  end
end
