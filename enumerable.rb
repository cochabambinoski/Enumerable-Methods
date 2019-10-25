# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    i = 0
    array2 = []
    while i < size
      array2 << self[i] if yield(self[i])
      i += 1
    end
    array2
  end

  def my_all?
    i = 0
    while i < size
      return false unless yield(self[i])

      i += 1
    end
    true
  end

  def my_any?
    i = 0
    while i < size
      return true if yield(self[i])

      i += 1
    end
    false
  end
end
