require 'json'

module Thingtrack
  def self.parse(source, opts = {})
    r = Rho::JSON.parse(source)
    r = keys_to_symbol(r) if opts[:symbolize_names]
    return r
  end
  
  def self.keys_to_symbol(h)
    new_hash = {}
    h.each do |k,v|
      if v.class == String || v.class == Fixnum || v.class == Float
        new_hash[k.to_sym] = v
      elsif v.class == Hash
        new_hash[k.to_sym] = keys_to_symbol(v)
      elsif v.class == Array
        new_hash[k.to_sym] = keys_to_symbol_array(v)
      else
        raise ArgumentError, "Type not supported: #{v.class}"
      end
    end
    return new_hash
  end
  
  def self.keys_to_symbol_array(array)
    new_array = []
    array.each do |i|
      if i.class == Hash
        new_array << keys_to_symbol(i)
      elsif i.class == Array
        new_array << keys_to_symbol_array(i)
      else
        new_array << i
      end
    end
    return new_array
  end
    
end