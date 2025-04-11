require 'rails_helper'

RSpec.describe "Products Show Page", type: :system do
  let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
  let(:child_taxon) { create(:taxon, name: "子カテゴリ", parent: parent_taxon) }
  let(:product) { create(:product, name: "テスト商品", taxons: [child_taxon]) }

  describe "breadcrumb display" do
    it "パンくずリストが正しく表示されること" do
      visit product_path(product.id)

      within('.breadcrumb') do
        expect(page).to have_content('ホーム')
        expect(page).to have_content(parent_taxon.name)
        expect(page).to have_content(child_taxon.name)
        expect(page).to have_content(product.name)
      end
    end
  end

  describe "breadcrumb links" do
    it "パンくずリストのリンクが機能すること" do
      visit product_path(product.id)

      within('.breadcrumb') do
        click_link 'ホーム'
      end
      expect(current_path).to eq(root_path)

      visit product_path(product.id)
      within('.breadcrumb') do
        click_link parent_taxon.name
      end
      expect(current_path).to eq(category_path(parent_taxon.id))

      visit product_path(product.id)
      within('.breadcrumb') do
        click_link child_taxon.name
      end
      expect(current_path).to eq(category_path(child_taxon.id))
    end
  end
end
