require 'rails_helper'
require 'nokogiri'

RSpec.describe "CategoriesController", type: :request do
  describe "GET #show" do
    context "通常のカテゴリ（パンくずを表示する）" do
      let(:taxon) { create(:taxon, name: "通常カテゴリ") }

      before { get category_path(taxon.id) }

      it "ステータスの確認" do
        expect(response).to have_http_status(200)
      end

      it "パンくずにカテゴリ名が含まれる" do
        doc = Nokogiri::HTML(response.body)
        breadcrumb_text = doc.css('ol.breadcrumb').text
        expect(breadcrumb_text).to include("ホーム")
        expect(breadcrumb_text).to include(taxon.name)
      end
    end

    shared_examples "パンくずから省略される特殊カテゴリ" do |category_name|
      let(:taxon) { create(:taxon, name: category_name) }

      before { get category_path(taxon.id) }

      it "レスポンスが成功する" do
        expect(response).to have_http_status(200)
      end

      it "#{category_name} はパンくずに含まれない" do
        doc = Nokogiri::HTML(response.body)
        breadcrumb_text = doc.css('ol.breadcrumb').text
        expect(breadcrumb_text).to include("ホーム")
        expect(breadcrumb_text).not_to include(taxon.name)
      end
    end

    context "特殊カテゴリ: Categories" do
      it_behaves_like "パンくずから省略される特殊カテゴリ", "Categories"
    end

    context "特殊カテゴリ: Brand" do
      it_behaves_like "パンくずから省略される特殊カテゴリ", "Brand"
    end
  end
end
