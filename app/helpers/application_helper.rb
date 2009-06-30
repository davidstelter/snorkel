# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pager_control(pager, n = 2)
    @output = ""
    if pager.page > 1
      @output << "<a href=\"?page=1\">\<\< </a>"
      @output << "<a href=\"?page=#{pager.page - 1}\">\< </a>"
    else
      @output << "\<\< \< "
    end
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

    for page in lower..upper
      if page == pager.page
        @output << "#{page} "
      else
        @output << "<a href=\"?page=#{page.to_s}\">#{page.to_s}</a> "
      end
    end

    if pager.page < pager.page_cnt
      @output << "<a href=\"?page=#{pager.page + 1}\">\> </a>"
      @output << "<a href=\"?page=#{pager.page_cnt}\">\>\></a>"
    else
      @output << "\> \>\>"
    end

    @output
  end

end
