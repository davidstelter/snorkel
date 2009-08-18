module Util

  #Returns min argument, or nil if one or both are nil
  def min(a, b)
    if a && b
      min = (a < b) ? a : b
    end

    if a
      min = a 
    else
      min = b
    end

    min
  end
  #Returns max argument, or nil if both are nil
  def max(a, b)
    if a && b
      max = (a > b) ? a : b
    end

    if a
      max = a 
    else
      max = b
    end

    max
  end
end
