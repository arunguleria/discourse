# frozen_string_literal: true

require "rails_helper"

RSpec.describe Chat::ThreadOriginalMessageSerializer do
  context "with mentions" do
    fab!(:message) { Fabricate(:message) }

    it "adds status to mentioned users if status is enabled" do
      SiteSetting.enable_user_status = true

      serializer = described_class.new(message)
      json = serializer.as_json

      expect(json[:mentioned_users][0][:status]).to be_present
      expect(json[:mentioned_users][0][:status][:description]).to eq("test")
      expect(json[:mentioned_users][0][:status][:emoji]).to eq("test")
    end

    it "does not add status to mentioned users if status is disabled" do
      SiteSetting.enable_user_status = false

      serializer = described_class.new(message)
      json = serializer.as_json

      expect(json[:mentioned_users][0][:status]).to be_nil
    end
  end
end
