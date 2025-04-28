require 'rails_helper'

RSpec.describe "Products", type: :system do
  describe "GET /show" do
    let(:root_taxon) { create(:taxon, name: 'ルートカテゴリー') }
    let(:parent_taxon) { create(:taxon, parent: root_taxon, name: '親カテゴリー') }
    let(:taxon) { create(:taxon, parent: parent_taxon, name: 'カテゴリー') }
    let(:product) { create(:product, taxons: [taxon], name: '商品名') }
    let!(:image) { create(:image) }

    before do
      product.images << image
      visit product_path(product.id)
    end

    it "商品詳細ページの商品名が表示されること" do
      expect(page).to have_content(product.name)
    end

    it "商品の価格が表示されること" do
      expect(page).to have_content(product.display_price.to_s)
    end

    it "商品詳細ページのページタイトルが表示されること" do
      expect(page).to have_title "#{product.name} - BIGBAG Store"
    end

    it "パンくずリストにホームリンクが表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link('ホーム', href: root_path)
      end
    end

    it "ホームへのリンクが機能すること" do
      within(all('.breadcrumb').first) do
        click_on 'ホーム'
      end
      expect(current_path).to eq root_path
    end

    it "現在のページの商品名がパンくずリストに表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_content(product.name)
      end
    end

    it "パンくずリストに親カテゴリのリンクが表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link(parent_taxon.name, href: category_path(taxon_id: parent_taxon.id))
        click_on parent_taxon.name
      end
      expect(page).to have_current_path(category_path(taxon_id: parent_taxon.id))
    end

    it "パンくずリストに子カテゴリのリンクが表示されること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link(taxon.name, href: category_path(taxon_id: taxon.id))
        click_on taxon.name
      end
      expect(page).to have_current_path(category_path(taxon_id: taxon.id))
    end

    it "パンくずリストにroot_taxonが表示されないこと" do
      within(all('.breadcrumb').first) do
        expect(page).not_to have_content(root_taxon.name)
      end
    end
  end
end
