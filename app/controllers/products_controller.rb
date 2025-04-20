class ProductsController < ApplicationController
  def show
    @product = Spree::Product.find(params[:id])

    # self_and_ancestors を使用して、タクソンとその親タクソンを取得
    @breadcrumbs = [
      { name: 'ホーム', path: root_path },
    ]

    @product.taxons.first.self_and_ancestors.each do |taxon|
      # 'Categories' や 'Brand' を除外するためにフィルタリング
      next if %w(Categories Brand).include?(taxon.name)

      @breadcrumbs << { name: taxon.name, path: category_path(taxon.id) }
    end

    # 最後に商品名を追加
    @breadcrumbs << { name: @product.name }
  end
end
