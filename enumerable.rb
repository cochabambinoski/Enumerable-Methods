# frozen_string_literal: true

module Enumerable
  def my_each
    if block_given?
      (0..length - 1).each do |i|
        yield(self[i])
      end
    else
      puts "You didn't send a block in"
    end
  end

  def my_each_with_index
    if block_given?
      (0..length - 1).each do |i|
        yield(self[i], i)
      end
    else
      puts "You didn't send a block in"
    end
  end

  def my_select
    if block_given?
      new_arr = []
      (0..length - 1).each do |i|
        new_arr.push(self[i]) if yield(self[i])
      end
      puts new_arr

    else
      puts "You didn't send a block in"
    end
  end

  def my_all?
    if block_given?
      result = true
      (0..length - 1).each do |i|
        next if yield(self[i])

        result = false
      end
    else
      "You didn't send a block in"
    end

    puts result
  end

  def my_any?
    if block_given?
      result = false
      (0..length - 1).each do |i|
        next unless yield(self[i])

        result = true
      end
    else
      "You didn't send a block in"
    end

    puts result
  end

  def my_none?
    if block_given?
      result = true
      (0..length - 1).each do |i|
        next unless yield(self[i])

        result = false
      end
    else
      "You didn't send a block in"
    end

    puts result
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

  def my_map
    if block_given?
      result = []
      (0..length - 1).each do |i|
        result.push(yield(self[i]))
      end
    else
      result = self
    end

    result
  end

  def my_inject(startval = nil, symbol = nil)
    if block_given?

      if !startval.nil?
        result = startval

      else
        result = self[0]
        shift

      end
      my_each do |element|
        result = yield(result, element)
      end
      result
    elsif !startval.nil? && !symbol.nil?
      result = startval
      my_each do |element|
        result = result.send(symbol, element)
      end
      result
    elsif !startval.nil? && symbol.nil?
      result = self[0]
      shift
      my_each do |element|
        result = result.send(startval, element)
      end
      result

    else
      "You didn't provide the correct parameters"
    end
  end
end
