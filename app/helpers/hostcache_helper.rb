module HostcacheHelper

  def cache_updated
    HostCache.last_updated
  end
end
