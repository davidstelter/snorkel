# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

module PagerControlHelper
  def pager_counts(pager, opts={})
    m = "#{pager.first_item} to #{pager.last_item} of "
    if opts[:count_link]
      m += link_to(pager.item_cnt, opts[:count_link])
    else
      m += "#{pager.item_cnt}"
    end
    m
  end

  def pager_control(pager, n = 3)
    params          = request.params.dup
    params[:page] ||= 1
    pager.page      = params[:page].to_i

    if (pager.page_cnt <= 1)
      return
    end
    @output = ""
    @output << link_to_unless(pager.page == 1, h("<<"), params.merge(:page => 1))
    @output << h(" ")
    @output << link_to_unless(pager.page == 1, h("<"), params.merge(:page => (pager.page - 1).to_s))
    @output << h(" ")

    lower = 0
    upper = 0

    if pager.page < (n + 1)
      lower = 1
      upper = 2*n + 1
    elsif pager.page > (pager.page_cnt - (2*n + 2))
      lower = (pager.page_cnt - (2*n))
      upper = pager.page_cnt 
    else
      lower = pager.page - n
      upper = pager.page + n
    end
    
    if upper > pager.page_cnt
      upper = pager.page_cnt
    end

    for page in lower..upper
      @output << link_to_unless(page == pager.page, page.to_s, params.merge(:page => page))
      @output << h(" ")
    end
    @output << link_to_unless(pager.page_cnt <= pager.page, h(">"), params.merge(:page => (pager.page + 1)))
    @output << h(" ")
    @output << link_to_unless(pager.page_cnt <= pager.page, h(">>"), params.merge(:page => (pager.page_cnt)))

    @output
  end
end
