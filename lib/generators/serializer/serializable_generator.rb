# frozen_string_literal: true

require_relative "serializer_generator"

class SerializableGenerator < SerializerGenerator
  source_root File.expand_path("templates", __dir__)

  def modify_model_file
    inject_into_class File.join("app/models", class_path, "#{class_name.underscore}.rb"), class_name do
      "  include Barley::Serializable\n"
    end
  end
end
