module SignaturesHelper
  def pager_control(pager)
    @output = ""
    for page in 1..pager.page_cnt
      @output << "<a href=\"?page=#{page.to_s}\">#{page.to_s}</a> "
    end
    @output
  end
end
