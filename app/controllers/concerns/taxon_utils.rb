module TaxonUtils
  extend ActiveSupport::Concern

  def get_ancestors(taxon)
    # 自身を含む先祖をすべて取得して、最上位カテゴリ（parent_idがnil）を除外し、順序を階層順に並べる(order(:lft))
    taxon.self_and_ancestors.where.not(parent_id: nil).order(:lft)
  end
end
