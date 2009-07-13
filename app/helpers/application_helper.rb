# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def dump_params
    ps = ""
    request.params.each do |key, val|
      ps << ":#{key} => #{val}</br>"
    end
    ps
  end
end
