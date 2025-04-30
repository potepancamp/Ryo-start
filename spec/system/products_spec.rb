require 'rails_helper'

RSpec.describe "Products", type: :system do
  describe "GET /show" do
    let(:root_taxon) { create(:taxon, name: '最上位カテゴリー') }
    let(:parent_taxon) { create(:taxon, parent: root_taxon, name: '親カテゴリー') }
    let(:taxon) { create(:taxon, parent: parent_taxon, name: 'テストカテゴリー') }
    let(:product) { create(:product, taxons: [taxon], name: '商品カテゴリ') }

    before do
      product.images << create(:image)
      visit product_path(product.id)
    end

    it "商品カテゴリのページタイトルが表示されること" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
    end

    it "商品カテゴリの商品名が表示されること" do
      expect(page).to have_content(product.name)
    end

    it "商品価格が表示されること" do
      expect(page).to have_content(product.display_price.to_s)
    end

    it "パンくずリストにホームへのリンクが機能すること" do
      within(all('.breadcrumb').first) do
        click_on 'ホーム'
      end
      expect(current_path).to eq root_path
    end

    it "パンくずリストに親カテゴリのリンクが表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link(parent_taxon.name, href: category_path(taxon_id: parent_taxon.id))
        click_on parent_taxon.name
      end
      expect(page).to have_current_path(category_path(taxon_id: parent_taxon.id))
    end

    it "パンくずリストにテストカテゴリーのリンクが表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link(taxon.name, href: category_path(taxon_id: taxon.id))
        click_on taxon.name
      end
      expect(page).to have_current_path(category_path(taxon_id: taxon.id))
    end

    it "現在のページの商品カテゴリがパンくずリストに表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_content(product.name)
      end
    end

    it "パンくずリストに最上位カテゴリーが表示されないこと" do
      within(all('.breadcrumb').first) do
        expect(page).not_to have_content(root_taxon.name)
      end
    end
  end
end
