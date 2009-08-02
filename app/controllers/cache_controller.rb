# Copyright © 2009 David Stelter
# This software is released under the terms of the Modified BSD License
# Please see the file COPYING in the root source directory for details

class CacheController < ApplicationController
  include ControllerCommon

  def update
    HostCache.update_cache
    respond_to do |format|
      format.js
    end
  end
end
