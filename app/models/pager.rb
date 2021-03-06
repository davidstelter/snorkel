# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class Pager
  @@per_page = 25
  attr_reader :page, :page_cnt, :item_cnt
  attr_writer :page, :page_cnt

   def Pager.per_page
    @@per_page
   end

   def per_page
     @@per_page
   end

  def initialize(item_cnt = 1, page_str = '1', per_page = 25)
    @item_cnt = item_cnt
    @page     = page_str.to_i
    @page = 1 if @page < 1

    @@per_page = per_page
    @page_cnt = (item_cnt / per_page)
    if (item_cnt % per_page > 0)
      @page_cnt += 1
    end
  end



  def offset
    (@page - 1) * @@per_page
  end

  def first_item
    (@page - 1) * @@per_page + 1
  end

  def last_item
    last = (@page * @@per_page)
    if last > @item_cnt
      last = @item_cnt
    end
    last
  end

end
