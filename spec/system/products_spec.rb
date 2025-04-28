require 'rails_helper'

RSpec.describe "Products", type: :system do
  describe "GET /show" do
    let(:root_taxon) { create(:taxon, name: 'Root Taxon') }
    let(:parent_taxon) { create(:taxon, parent: root_taxon, name: 'Parent Taxon') }
    let(:child_taxon) { create(:taxon, parent: parent_taxon, name: 'Child Taxon') }
    let(:product) { create(:product, taxons: [child_taxon], name: 'Product') }
    let!(:image) { create(:image) }

    before do
      product.images << image
      visit product_path(product.id)
    end

    it "パンくずリストにホームリンクが含まれること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link('ホーム', href: root_path)
        click_on 'ホーム'
      end
      expect(page).to have_current_path(root_path)
    end

    it "現在のページの商品名がパンくずリストに含まれること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_content(product.name)
      end
    end

    it "パンくずリストに親カテゴリのリンクが含まれること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link(parent_taxon.name, href: category_path(taxon_id: parent_taxon.id))
        click_on parent_taxon.name
      end
      expect(page).to have_current_path(category_path(taxon_id: parent_taxon.id))
    end
    
    it "パンくずリストに子カテゴリのリンクが含まれること" do
      within(all('.breadcrumb').first) do
        expect(page).to have_link(child_taxon.name, href: category_path(taxon_id: child_taxon.id))
        click_on child_taxon.name
      end
      expect(page).to have_current_path(category_path(taxon_id: child_taxon.id))
    end
    

    it "パンくずリストにroot_taxonが表示されないこと" do
      within(all('.breadcrumb').first) do
        expect(page).not_to have_content(root_taxon.name)
      end
    end

    it "商品詳細ページの商品名が表示されること" do
      expect(page).to have_content(product.name)
    end

    it "商品の価格が表示されること" do
      expect(page).to have_content(product.display_price.to_s)
    end
  end
end
