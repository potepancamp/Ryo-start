require 'rails_helper'
require Rails.root.join("app/models/product_decorator.rb")

RSpec.describe Spree::Product, type: :model do
  let(:ancestor) { create(:taxon, name: "親カテゴリー") }
  let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
  let!(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
  let!(:related_product) { create(:product, taxons: [taxon]) }
  let!(:unrelated_product) { create(:product) }

  describe "#related_products" do
    subject { product.related_products }

    it "自分自身を含まないこと" do
      is_expected.not_to include(product)
    end

    it "同じカテゴリに属する他の商品を含むこと" do
      is_expected.to include(related_product)
    end

    it "異なるカテゴリの商品は含まないこと" do
      is_expected.not_to include(unrelated_product)
    end

    context '別の商品が同じカテゴリに属する' do
      let(:other_taxon) { create(:taxon, name: "別カテゴリ") }
      let!(:other_product) { create(:product, name: "別カテゴリ商品", taxons: [taxon, other_taxon]) }

      before do
        related_product.taxons << other_taxon
        related_product.save!
      end

      it "重複を含まないこと" do
        expect(subject.ids).to eq [related_product.id, other_product.id]
      end
    end
  end
end
