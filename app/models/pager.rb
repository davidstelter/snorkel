class Pager
  attr_reader :page, :page_cnt, :item_cnt, :per_page
  attr_writer :page, :per_page

  def initialize(item_cnt, page_str, per_page = 30)
    @item_cnt = item_cnt
    @page     = page_str.to_i
    @per_page = per_page
    @page_cnt = (item_cnt / per_page)
    if (item_cnt % per_page)
      @page_cnt += 1
    end
  end

  def offset
    (@page - 1) * @per_page
  end

end
