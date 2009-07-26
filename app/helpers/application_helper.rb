# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def link_to_unless_zero(link_text, params = {})
    link_to_unless (link_text == 0), link_text, params
  end

  def cidr_select(name)
    options = ""
    (0..31).each { |num| options << "<option>#{num}</option>"}
    select_tag(name, options)
  end

  def dump_params
    ps = ""
    request.params.each do |key, val|
      ps << ":#{key} => #{val}</br>"
    end
    ps
  end
end
