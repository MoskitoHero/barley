module Barley
  class Middleware
  def self.register(serializer)
    binding.break
    serializer.register_middleware(:before_serialize, self)
    serializer.register_middleware(:after_serialize, self)
  end

  def call(key, key_name:, **options)
    puts "Hook called with key: #{key}, key_name: #{key_name}, options: #{options}"
  end
end
end
