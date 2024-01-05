# frozen_string_literal: true

module Chat
  class ThreadOriginalMessageSerializer < ::ApplicationSerializer
    attributes :id,
               :message,
               :cooked,
               :created_at,
               :excerpt,
               :chat_channel_id,
               :deleted_at,
               :mentioned_users

    def initialize(object, options = nil)
      super
      options[:include_status] = true
    end

    def excerpt
      object.censored_excerpt
    end

    def mentioned_users
      object
        .chat_mentions
        .map(&:user)
        .compact
        .sort_by(&:id)
        .map { |user| BasicUserSerializer.new(user, root: false, include_status: true) }
        .as_json
    end

    has_one :user, serializer: BasicUserSerializer, embed: :objects
  end
end
