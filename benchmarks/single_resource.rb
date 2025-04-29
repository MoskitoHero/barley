# Benchmark script to run varieties of JSON serializers
# Fetch Barley from local, otherwise fetch latest from RubyGems

require_relative "prep"

# --- Alba serializers ---

require "alba"

class AlbaCommentResource
  include ::Alba::Resource
  attributes :id, :body
end

class AlbaPostResource
  include ::Alba::Resource
  attributes :id, :body
  attribute :commenter_names do |post|
    post.commenters.pluck(:name)
  end
  many :comments, resource: AlbaCommentResource
end

# --- ActiveModelSerializer serializers ---

require "active_model_serializers"

class AMSCommentSerializer < ActiveModel::Serializer
  attributes :id, :body
end

class AMSPostSerializer < ActiveModel::Serializer
  attributes :id, :body
  attribute :commenter_names
  has_many :comments, serializer: AMSCommentSerializer

  def commenter_names
    object.commenters.pluck(:name)
  end
end

# --- Barley serializers ---

require "barley"

class BarleyCommentSerializer < Barley::Serializer
  attributes :id, :body
end

class BarleyPostSerializer < Barley::Serializer
  attributes :id, :body
  attribute :commenter_names
  many :comments, serializer: BarleyCommentSerializer

  def commenter_names
    object.commenters.pluck(:name)
  end
end

# --- Blueprint serializers ---

require "blueprinter"

class CommentBlueprint < Blueprinter::Base
  fields :id, :body
end

class PostBlueprint < Blueprinter::Base
  fields :id, :body, :commenter_names
  association :comments, blueprint: CommentBlueprint

  def commenter_names
    commenters.pluck(:name)
  end
end

# --- JBuilder serializers ---

require "jbuilder"

class Post
  def to_builder
    Jbuilder.new do |post|
      post.call(self, :id, :body, :commenter_names, :comments)
    end
  end

  def commenter_names
    commenters.pluck(:name)
  end
end

class Comment
  def to_builder
    Jbuilder.new do |comment|
      comment.call(self, :id, :body)
    end
  end
end

# --- Jserializer serializers ---

require "jserializer"

class JserializerCommentSerializer < Jserializer::Base
  attributes :id, :body
end

class JserializerPostSerializer < Jserializer::Base
  attributes :id, :body, :commenter_names
  has_many :comments, serializer: JserializerCommentSerializer
  def commenter_names
    object.commenters.pluck(:name)
  end
end

# --- Panko serializers ---

require "panko_serializer"

class PankoCommentSerializer < Panko::Serializer
  attributes :id, :body
end

class PankoPostSerializer < Panko::Serializer
  attributes :id, :body, :commenter_names

  has_many :comments, serializer: PankoCommentSerializer

  def commenter_names
    object.commenters.pluck(:name)
  end
end

# --- Representable serializers ---

require "representable"

class CommentRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :body
end

class PostRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :body
  property :commenter_names
  collection :comments

  def commenter_names
    commenters.pluck(:name)
  end
end

# --- SimpleAMS serializers ---

require "simple_ams"

class SimpleAMSCommentSerializer
  include SimpleAMS::DSL

  attributes :id, :body
end

class SimpleAMSPostSerializer
  include SimpleAMS::DSL

  attributes :id, :body
  attribute :commenter_names
  has_many :comments, serializer: SimpleAMSCommentSerializer

  def commenter_names
    object.commenters.pluck(:name)
  end
end

require "turbostreamer"
TurboStreamer.set_default_encoder(:json, :oj)

class TurbostreamerSerializer
  def initialize(post)
    @post = post
  end

  def to_json(*_args)
    TurboStreamer.encode do |json|
      json.object! do
        json.extract! @post, :id, :body, :commenter_names

        json.comments @post.comments do |comment|
          json.object! do
            json.extract! comment, :id, :body
          end
        end
      end
    end
  end
end

# --- Test data creation ---

post = Post.create!(body: "post")
user1 = User.create!(name: "John")
user2 = User.create!(name: "Jane")
post.comments.create!(commenter: user1, body: "Comment1")
post.comments.create!(commenter: user2, body: "Comment2")
post.reload

# --- Store the serializers in procs ---

alba = proc { AlbaPostResource.new(post).serialize }
alba_inline = proc do
  Alba.serialize(post) do
    attributes :id, :body
    attribute :commenter_names do |post|
      post.commenters.pluck(:name)
    end
    many :comments do
      attributes :id, :body
    end
  end
end

ams = proc { AMSPostSerializer.new(post, {}).to_json }
barley = proc { BarleyPostSerializer.new(post).serializable_hash.to_json }
barley_cache = proc { BarleyPostSerializer.new(post, cache: true).serializable_hash.to_json }
blueprinter = proc { PostBlueprint.render(post) }
jbuilder = proc { post.to_builder.target! }
jserializer = proc { JserializerPostSerializer.new(post).to_json }
panko = proc { PankoPostSerializer.new.serialize_to_json(post) }
rails = proc { ActiveSupport::JSON.encode(post.serializable_hash(include: :comments)) }
representable = proc { PostRepresenter.new(post).to_json }
simple_ams = proc { SimpleAMS::Renderer.new(post, serializer: SimpleAMSPostSerializer).to_json }
turbostreamer = proc { TurbostreamerSerializer.new(post).to_json }

# --- Execute the serializers to check their output ---

puts "Serializer outputs ----------------------------------"
{
  alba: alba,
  alba_inline: alba_inline,
  ams: ams,
  barley: barley,
  barley_cache: barley_cache,
  blueprinter: blueprinter,
  jbuilder: jbuilder, # different order
  jserializer: jserializer,
  panko: panko,
  rails: rails,
  representable: representable,
  simple_ams: simple_ams,
  turbostreamer: turbostreamer
}.each do |name, serializer|
  puts "#{name.to_s.ljust(24, " ")} #{serializer.call}"
end

# --- Run the benchmarks ---

require "benchmark/ips"
Benchmark.ips do |x|
  x.report(:alba, &alba)
  x.report(:alba_inline, &alba_inline)
  x.report(:ams, &ams)
  x.report(:barley, &barley)
  x.report(:barley_cache, &barley_cache)
  x.report(:blueprinter, &blueprinter)
  x.report(:jbuilder, &jbuilder)
  x.report(:jserializer, &jserializer)
  x.report(:panko, &panko)
  x.report(:rails, &rails)
  x.report(:representable, &representable)
  x.report(:simple_ams, &simple_ams)
  x.report(:turbostreamer, &turbostreamer)

  x.compare!
end

require "benchmark/memory"
Benchmark.memory do |x|
  x.report(:alba, &alba)
  x.report(:alba_inline, &alba_inline)
  x.report(:ams, &ams)
  x.report(:barley, &barley)
  x.report(:barley_cache, &barley_cache)
  x.report(:blueprinter, &blueprinter)
  x.report(:jbuilder, &jbuilder)
  x.report(:jserializer, &jserializer)
  x.report(:panko, &panko)
  x.report(:rails, &rails)
  x.report(:representable, &representable)
  x.report(:simple_ams, &simple_ams)
  x.report(:turbostreamer, &turbostreamer)

  x.compare!
end
