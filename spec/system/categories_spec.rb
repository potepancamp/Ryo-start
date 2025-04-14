require 'rails_helper'

RSpec.describe "Categories Show Page", type: :system do
  describe "カテゴリー詳細ページ" do
    let(:product) { create(:product) }
    let(:taxon) { create(:taxon, products: [product]) }
    let(:image) { create(:image) }

    before do
      product.images << image
      visit category_path(taxon.id)
    end

    it "ページタイトルが表示されること" do
      expect(page).to have_title "#{taxon.name} - BIGBAG Store"
    end

    it "パンくずリストが正しく表示されること" do
      within('.breadcrumb') do
        expect(page).to have_link 'ホーム', href: root_path
        expect(page).to have_link taxon.name, href: category_path(taxon.id)
        expect(page).not_to have_link 'Categories'
        expect(page).not_to have_link 'Brand'
      end
    end

    it "商品名が表示されること" do
      expect(page).to have_content product.name
    end

    it "商品価格が表示されること" do
      expect(page).to have_content product.display_price
    end

    it "パンくずリストのリンクが機能すること" do
      visit category_path(taxon.id)

      within('.breadcrumb') do
        click_on 'ホーム'
      end
      expect(current_path).to eq root_path

      visit category_path(taxon.id)

      within('.breadcrumb') do
        click_on taxon.name
      end
      expect(current_path).to eq category_path(taxon.id)

      within('.breadcrumb') do
        expect(page).not_to have_link 'Categories'
        expect(page).not_to have_link 'Brand'
      end
    end
  end
end
