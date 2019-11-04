# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    (0..length - 1).each do |i|
      yield(self[i])
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    (0..length - 1).each do |i|
      yield(self[i], i)
    end
  end

  def my_select
    return to_enum unless block_given?

    new_arr = []
    (0..length - 1).each do |i|
      new_arr.push(self[i]) if yield(self[i])
    end
    new_arr
  end

  def my_all?(*arg)
    if block_given?
      my_each do |i|
        return false unless yield(i)
      end
    elsif !arg.empty?
      if arg[0].is_a? Numeric
        my_each do |i|
          return false if i != arg[0]
        end
      elsif arg[0].class == Regexp
        my_each do |i|
          return false if i !~ arg[0]
        end
      else
        my_each do |i|
          return false unless i.is_a? arg[0]
        end
      end
    else
      my_each do |i|
        return false if i.nil? || i == false
      end
    end
    true
  end

  def my_any?(*arg)
    if block_given?
      my_each do |i|
        return true if yield(i)
      end
    elsif !arg.empty?
      if arg[0].is_a? Numeric
        my_each do |i|
          return true if i == arg[0]
        end
      elsif arg[0].class == Regexp
        my_each do |i|
          return true if i =~ arg[0]
        end
      elsif arg[0].is_a? String
        my_each do |i|
          return true if i == arg[0]
        end
      else
        my_each do |i|
          return true if i.is_a? arg[0]
        end
      end
    else
      return false if empty?

      my_each do |i|
        return true if !i.nil? && i != false
      end
    end
    false
  end

  def my_none?(*arg)
    if block_given?
      puts "block given"
      my_each do |i|
        return false if yield(i)
      end
    elsif !arg.empty?
      puts "arg given"
      if arg[0].is_a? Numeric
        my_each do |i|
          return false if i == arg[0]
        end
      elsif arg[0].class == Regexp
        puts "Regexp"
        my_each do |i|
          return false if arg[0] =~ i
        end
      else
        my_each do |i|
          return false if i.is_a? arg[0]
        end
      end
    else
      return true if empty?

      my_each do |i|
        return false if i
      end
    end
    true
  end

  def my_count(num = nil)
    count = 0
    if block_given?
      (0..length - 1).each do |i|
        next unless yield(self[i])

        count += 1
      end
    elsif num
      my_each do |i|
        count += 1 if i == num
      end
    else
      my_each do |_i|
        count += 1
      end
    end
    count
  end

  def my_map(proc = nil)
    return_array = []
    return to_enum :my_map if !block_given? && proc.nil?

    to_a.my_each do |i|
      return_array.push(proc.call(i)) unless proc.nil?
      return_array.push(yield(i)) if block_given? && proc.nil?
    end
    return_array
  end

  def my_inject(*args)
    sum = 0
    wsum = ""
    i = 0
    raise ArgumentError, "wrong number of arguments (given 3, expected 0..2)" if args.length > 2

    if args[1].is_a?(Symbol) && args[0].is_a?(Integer)
      sum = args[0]
      to_a.my_each { |element| sum = sum.method(args[1]).call(element) }
    elsif args.empty? && block_given?
      to_a.my_each do |element|
        if element.is_a?(Integer)
          i == 0 ? sum += element : sum = yield(sum, element)
        else
          i == 0 ? wsum += element : wsum = yield(wsum, element)
        end
        i += 1
      end
      return sum if wsum.empty?

      return wsum
    elsif args[0].is_a?(Integer) && block_given?
      sum = args[0]
      to_a.my_each { |element| sum = yield(sum, element) }
    elsif args.length == 1 && block_given? == false
      raise TypeError, "#{args[0]} (not symbol/string)" if args[0].class != Symbol && args[0].class != String

      if args[0].is_a?(Symbol)
        to_a.my_each do |element|
          i == 0 ? sum += element : sum = sum.method(args[0]).call(element)
          i += 1
        end
      elsif args[0].is_a?(String)
        operators = %i[+ - * / == =~]
        if operators.my_any? { |o| o == args[0].to_sym }
          my_each do |element|
            i == 0 ? sum += element : sum = sum.method(args[0].to_sym).call(element)
            i += 1
          end
        else
          raise NoMethodError, "undefined method '#{args[0]}' for Integer"
        end
      end
    end
    sum
  end
end
