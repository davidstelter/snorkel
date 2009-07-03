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

  def ip_header(iphdr)
    iphdr_s = %{
      <table border id=ipheader>
        <tr>
          <div display="none">
    }
    32.times do 
      iphdr_s << %{<th>&nbsp;</th>}
    end
    iphdr_s << %{</div>
        <tr>
          <td colspan=4>IP Ver</td><td colspan=4>HLEN</td><td colspan=8>TOS</td><td colspan=16>PKTLEN</td>
        </tr>
        <tr>
          <td colspan=4>#{iphdr.ip_ver}</td>
          <td colspan=4>#{iphdr.ip_hlen}</td>
          <td colspan=8>#{iphdr.ip_tos}</td>
          <td colspan=16>#{iphdr.ip_len}</td>
        </tr>
        <tr>
          <td colspan=16>IP ID</td><td colspan=3>FLAGS</td><td colspan=13>OFFSET</td>
        </tr>
        <tr>
          <td colspan=16>0x#{iphdr.ip_id}</td>
          <td colspan=3>#{iphdr.ip_flags}</td>
          <td colspan=13>#{iphdr.ip_off}</td>
        </tr>
        <tr>
          <td colspan=8>TTL</td><td colspan=8>PROTO</td><td colspan=16>CHKSUM</td>
        </tr>
        <tr>
          <td colspan=8>#{iphdr.ip_ttl}</td>
          <td colspan=8>#{iphdr.ip_proto}</td>
          <td colspan=16>0x#{iphdr.ip_csum.to_s.hex}</td>
        </tr>
        <tr>
          <td colspan=32>Src IP</td>
        </tr>
        <tr>
          <td colspan=32>#{iphdr.ip_src_string}</td>
        </tr>
        <tr>
          <td colspan=32>Dst IP</td>
        </tr>
        <tr>
          <td colspan=32>#{iphdr.ip_dst_string}</td>
        </tr>
      </table> 
    }
    iphdr_s
  end

end
