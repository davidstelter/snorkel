# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pager_control(pager, n = 3)
    if (pager.page_cnt <= 1)
      return
    end
    @output = ""
    @output << link_to_unless(pager.page == 1, h("<<"), :page => 1)
    @output << h(" ")
    @output << link_to_unless(pager.page == 1, h("<"), :page => (pager.page - 1))
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

    for page in lower..upper
      @output << link_to_unless(page == pager.page, page.to_s, :page => page)
      @output << h(" ")
    end
    @output << link_to_unless(pager.page_cnt <= pager.page, h(">"), :page => (pager.page + 1))
    @output << h(" ")
    @output << link_to_unless(pager.page_cnt <= pager.page, h(">>"), :page => (pager.page_cnt))

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
    hdr_s = %{<div id="packet-headers">}
    hdr_s << ip_header(iphdr)

    if (iphdr.tcphdr)
      hdr_s << tcp_header(iphdr.tcphdr)
    end

    if (iphdr.udphdr)
      hdr_s << udp_header(iphdr.udphdr)
    end

    if (iphdr.data)
      hdr_s << packet_dump(iphdr.data)
    end
    
    hdr_s << %{</div>}
  end

  def packet_dump(data)
    p = data.data_payload
    data_s = %{
      <div class="packet-header">
        <table class="data-tab">
          <caption>PAYLOAD</caption>
          <tr><td><div id="scroller">
            <table id="scrolltab">
    }
    0.step(p.length, 16) { |i|
      data_s << %{
          <tr>
            <td id="data-offset">#{i.to_s(base=16)}:</td>
            <td id="data-hex">
                #{p[i,   4].downcase}&nbsp;
                #{p[i+4, 4].downcase if p[i+4, 4]} &nbsp;
                #{p[i+8, 4].downcase if p[i+8, 4]}&nbsp;
                #{p[i+12,4].downcase if p[i+12,4]}
            </td>
            <td id="data-ascii">
      }
    
      i.step(i+15, 2) { |j|
        if (j < p.length)
          d = p[(j),2].to_s.to_i(base=16)
          #if (d >= 0x7f || d <= 0x32)
           # data_s << "."
          #else
            data_s << %{#{h d.chr}}
          #end
        end
      }
    } 
    data_s << %{
       </table> </div></td></tr>
      </table>
    </div>
    }
  end

  def udp_header(udphdr)
    udphdr_s = %{
      <div class="packet-header">
        <table>
          <caption>UDP Header</caption>
          <tr>
    }
    udphdr_s << dummy_cells(32)
    udphdr_s << %{
          </tr>
          <tr>
            <th colspan=16>SRC PORT</th><th colspan=16>DST PORT</th>
          </tr>
          <tr>
            <td colspan=16>#{udphdr.udp_sport}</td>
            <td colspan=16>#{udphdr.udp_dport}</td>
          </tr>
          <tr>
            <th colspan=16>LEN</th><th colspan=16>CHKSUM</th>
          </tr>
          <tr>
            <td colspan=16>#{udphdr.udp_len}</td>
            <td colspan=16>0x#{udphdr.udp_csum.to_s.hex}</td>
          <tr>
        </table>
      </div>
    }
  end

  def tcp_header(tcphdr)
    urg = ""
    ack = ""
    psh = ""
    rst = ""
    syn = ""
    fin = ""

    if (tcphdr.tcp_flags[5] == 1)
      urg = "U"
    end
    if (tcphdr.tcp_flags[4] == 1)
      ack = "A"
    end
    if (tcphdr.tcp_flags[3] == 1)
      psh = "P"
    end
    if (tcphdr.tcp_flags[2] == 1)
      rst = "R"
    end
    if (tcphdr.tcp_flags[1] == 1)
      syn = "S"
    end
    if (tcphdr.tcp_flags[0] == 1)
      fin = "F"
    end

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
            <td colspan=1>#{urg}</td>
            <td colspan=1>#{ack}</td>
            <td colspan=1>#{psh}</td>
            <td colspan=1>#{rst}</td>
            <td colspan=1>#{syn}</td>
            <td colspan=1>#{fin}</td>
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
    res = ""
    df  = ""
    mf  = ""

    if (iphdr.ip_flags[2] == 1)
      res = "R"
    end
    if (iphdr.ip_flags[1] == 1)
      df = "D"
    end
    if (iphdr.ip_flags[0] == 1)
      mf = "M"
    end

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
          <td colspan=1>#{res}</td>
          <td colspan=1>#{df}</td>
          <td colspan=1>#{mf}</td>
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
