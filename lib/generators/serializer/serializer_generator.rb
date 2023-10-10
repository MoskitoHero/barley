# frozen_string_literal: true

class SerializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :name, type: :string, desc: "Custom serializer name"

  def create_serializer_file
    @serializer_name = options[:name] || "#{class_name}Serializer"
    file_name = @serializer_name.underscore
    template "serializer.erb", File.join("app/serializers", class_path, "#{file_name}.rb")
  end

  def create_test_file
    @serializer_name = options[:name] || "#{class_name}Serializer"
    (Bundler.load.specs.find { |s| s.name == "rspec-rails" }) ? create_rspec_test_file : create_minitest_test_file
  end

  private

  def create_rspec_test_file
    file_name = @serializer_name.underscore
    template "serializer_spec.erb", File.join("spec/serializers", class_path, "#{file_name}_spec.rb")
  end

  def create_minitest_test_file
    file_name = @serializer_name.underscore
    template "serializer_test.erb", File.join("test/serializers", class_path, "#{file_name}_test.rb")
  end
end
