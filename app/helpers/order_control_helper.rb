# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

module OrderControlHelper
  def order_control(text, args={})
    params     = request.params.dup
    ordered_up = params[:order]
    ordered_dn = params[:order_desc]
    params[:order]      = nil
    params[:order_desc] = nil
    field = args[:field] || text

    order_s = %{<span class="up-img">}

    if ordered_up == field
      order_s << image_tag("act-up11x11.png")
    else
      order_s << link_to(image_tag("up11x11.png", :border => 0), params.merge(:order => field))
    end

    order_s << %{</span>#{h(text)}<span class="dn-img">}

    if ordered_dn == field
      order_s << image_tag("act-dn11x11.png")
    else
      order_s << link_to(image_tag("dn11x11.png", :border => 0), params.merge(:order_desc => field))
    end

    order_s << %{</span>}
  end
end
