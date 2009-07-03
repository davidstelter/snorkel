# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Pager
  attr_reader :page, :page_cnt, :item_cnt, :per_page
  attr_writer :page, :per_page

  def initialize(item_cnt, page_str = '1', per_page = 25)
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
