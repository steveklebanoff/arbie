defmodule Arbie.Calculations do
  # computes the largest % difference
  # for a list of numbers
  def percentage_difference(n) do
    compacted = Enum.filter(n, fn(x) -> x != nil end)
    if Enum.empty?(compacted) do
       nil
    else
      sorted = Enum.sort(compacted)
      count = Enum.count(sorted)

      smallest = Enum.fetch! sorted, 0
      largest = Enum.fetch! sorted, count - 1

      if largest == 0 do
        0
      else
        ((largest - smallest) / smallest) * 100
      end
    end
  end
end
