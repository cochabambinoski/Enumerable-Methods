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

  def my_none?
    i = 0
    while i < size
      return false if yield(self[i])

      i += 1
    end
    true
  end

  def my_count(val = "NoNArG")
    count = 0
    if block_given?

      (0..length - 1).each do |i|
        next unless yield(self[i])

        count += 1
      end

    elsif val != "NoNArG"

      (0..length - 1).each do |i|
        count += 1 if self[i] == val
      end

    else
      count = length
    end

    count
  end

  def my_map(&proc)
    i = 0
    array2 = []
    while i < size
      array2 << if block_given?
                  yield(self[i])
                else
                  proc.call(self[i])
                end
      i += 1
    end
    array2
  end

  def my_inject(start = 0)
    i = 0
    accumulator = start
    while i < size
      accumulator = yield(accumulator, self[i])
      i += 1
    end
    accumulator
  end
end
