# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

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

  def dummy_cells(num)
    cells_s = ""
    num.times do
      cells_s << %{<td class="dummy-cell"></td>}
    end
    cells_s
  end

  def packet_headers(iphdr)
    hdr_s = ip_header(iphdr)

    if(iphdr.tcphdr)
      hdr_s << tcp_header(iphdr.tcphdr)
    end
    
    hdr_s
  end

  def tcp_header(tcphdr)
    tcphdr_s = %{
      <div class="packet-header">
        <table>
          <caption>TCP Header</caption>
          <tr>
    }
    tcphdr_s << dummy_cells(32)
    tcphdr_s << %{
          </tr>
          <tr>
            <th colspan=16>SRCPORT</th><th colspan=16>DSTPORT</th>
          </tr>
          <tr>
            <td colspan=16>#{tcphdr.tcp_sport}</td>
            <td colspan=16>#{tcphdr.tcp_dport}</td>
          </tr>
          <tr>
            <th colspan=32>SEQ NUM</th>
          </tr>
          <tr>
            <td colspan=32>0x#{tcphdr.tcp_seq.to_s.hex}</td>
          </tr>
          <tr>
            <th colspan=32>ACK NUM</th>
          </tr>
          <tr>
            <td colspan=32>0x#{tcphdr.tcp_ack.to_s.hex}</td>
          </tr>
          <tr>
            <th colspan=4>LEN</th><th colspan=6>RSVD</th><th colspan=6>FLAGS</th><th colspan=16>WINDOW</th>
          </tr>
          <tr>
            <td colspan=4>#{tcphdr.tcp_off}</td>
            <td colspan=6>0x#{tcphdr.tcp_res.to_s.hex}</td>
            <td colspan=6>#{tcphdr.tcp_flags}</td>
            <td colspan=16>#{tcphdr.tcp_win}</td>
          </tr>
          <tr>
            <th colspan=16>CHKSUM</th><th colspan=16>URG PTR</th>
          </tr>
          <tr>
            <td colspan=16>0x#{tcphdr.tcp_csum}</td>
            <td colspan=16>0x#{tcphdr.tcp_urp}</td>
          </tr>
        </table>
      </div>
    }
  end


  def ip_header(iphdr)
    iphdr_s = %{
    <div class="packet-header">
      <table>
        <caption>IP Header</caption>
        <tr>
    }
    iphdr_s << dummy_cells(32)
    iphdr_s << %{
        </tr>
        <tr>
          <th colspan=4>IP Ver</th><th colspan=4>HLEN</th><th colspan=8>TOS</th><th colspan=16>PKTLEN</th>
        </tr>
        <tr>
          <td colspan=4>#{iphdr.ip_ver}</td>
          <td colspan=4>#{iphdr.ip_hlen}</td>
          <td colspan=8>#{iphdr.ip_tos}</td>
          <td colspan=16>#{iphdr.ip_len}</td>
        </tr>
        <tr>
          <th colspan=16>IP ID</th><th colspan=3>FLG</th><th colspan=13>OFFSET</th>
        </tr>
        <tr>
          <td colspan=16>0x#{iphdr.ip_id}</td>
          <td colspan=3>#{iphdr.ip_flags}</td>
          <td colspan=13>#{iphdr.ip_off}</td>
        </tr>
        <tr>
          <th colspan=8>TTL</th><th colspan=8>PROTO</th><th colspan=16>CHKSUM</th>
        </tr>
        <tr>
          <td colspan=8>#{iphdr.ip_ttl}</td>
          <td colspan=8>#{iphdr.ip_proto}</td>
          <td colspan=16>0x#{iphdr.ip_csum.to_s.hex}</td>
        </tr>
        <tr>
          <th colspan=32>Src IP</th>
        </tr>
        <tr>
          <td colspan=32>#{iphdr.ip_src_string}</td>
        </tr>
        <tr>
          <th colspan=32>Dst IP</th>
        </tr>
        <tr>
          <td colspan=32>#{iphdr.ip_dst_string}</td>
        </tr>
      </table> 
    </div>
    }
    iphdr_s
  end

end
