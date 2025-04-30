RSpec.describe "Products", type: :request do
  describe "GET /products/:id" do
    let(:ancestor) { create(:taxon, name: "親カテゴリー") }
    let(:taxon) { create(:taxon, name: "テストカテゴリー", parent: ancestor) }
    let(:product) { create(:product, name: "カテゴリ商品", taxons: [taxon]) }
    let!(:related_products) { create_list(:product, 5, taxons: [taxon]) }

    # 画像を関連商品に紐づける
    before do
      # 画像をメイン商品に追加
      product.images << create(:image, viewable: product)

      # 画像を関連商品に追加
      related_products.each do |related_product|
        related_product.images << create(:image, viewable: related_product)
      end

      # 商品詳細ページのリクエスト
      get product_path(product.id)
    end

    it "200 OKであること" do
      expect(response).to have_http_status(200)
    end

    it "カテゴリ商品のタイトルが含まれていること" do
      expect(response.body).to include("#{product.name} - BIGBAG Store")
    end

    it "カテゴリ商品が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "商品価格が含まれていること" do
      expect(response.body).to include(product.display_price.to_s)
    end

    it "パンくずリストにテストカテゴリーが含まれていること" do
      expect(response.body).to include(taxon.name)
    end

    it "パンくずリストに商品名が含まれていること" do
      expect(response.body).to include(product.name)
    end

    it "関連商品の価格が表示されていること" do
      related_products.each do |related_product|
        expect(response.body).to include(related_product.display_price.to_s)
      end
    end

    it "関連商品の画像が含まれていること" do
      related_products.each do |related_product|
        expect(related_product.images.first).not_to be_nil
        expect(related_product.images.first.attachment.url).not_to be_nil
      end
    end

    it "一緒に見られている商品が最大4件表示されること" do
      # 最初の4件が含まれていること
      related_products.first(4).each do |related_product|
        expect(response.body).to include(related_product.name)
      end

      # 5件目は表示されていないこと
      expect(response.body).not_to include(related_products[4].name)
      
      # 最大4件が表示されていることを確認する
      expect(response.body.scan(/Product/).count).to eq(4)  # 商品名が4回だけ出現しているか確認
    end
  end
end
