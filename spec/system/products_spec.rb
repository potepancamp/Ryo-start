require 'rails_helper'

RSpec.describe "Products Show Page", type: :system do
  describe "商品詳細ページ" do
    let(:parent_taxon) { create(:taxon, name: "親カテゴリ") }
    let(:child_taxon) { create(:taxon, name: "子カテゴリ", parent: parent_taxon) }
    let(:product) { create(:product, name: "テスト商品", taxons: [child_taxon]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit product_path(product.id)
    end

    it "ページタイトルが表示されること" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
    end

    it "パンくずリストが正しく表示されること" do
      within('.breadcrumb') do
        expect(page).to have_link 'ホーム', href: root_path
        expect(page).to have_link parent_taxon.name, href: category_path(parent_taxon.id)
        expect(page).to have_link child_taxon.name, href: category_path(child_taxon.id)
        expect(page).to have_content product.name
      end
    end

    it "商品名が表示されること" do
      expect(page).to have_content product.name
    end

    it "商品価格が表示されること" do
      expect(page).to have_content product.display_price
    end

    it "パンくずリストのリンクが機能すること" do
      within('.breadcrumb') { click_link 'ホーム' }
      expect(current_path).to eq root_path

      visit product_path(product.id)
      within('.breadcrumb') { click_link parent_taxon.name }
      expect(current_path).to eq category_path(parent_taxon.id)

      visit product_path(product.id)
      within('.breadcrumb') { click_link child_taxon.name }
      expect(current_path).to eq category_path(child_taxon.id)
    end
  end
end
