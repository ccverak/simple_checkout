# frozen_string_literal: true

require "spec_helper"

RSpec.describe CabClient::Client do
  describe "#initialize" do
    before do
      CabClient.configure do |config|
        config.api_base = "http://api.foo.com"
        config.timeout = 200
      end
    end

    context "when no options are given" do
      subject { CabClient::Client.new }

      it "sets global options" do
        CabClient::Configurable::OPTIONS.each do |key|
          expect(subject.send(key)).to eq(CabClient.send(key))
        end
      end
    end

    context "when custom options are given" do
      subject { CabClient::Client.new(api_base: "http://api.bar.com", timeout: 12) }

      it "sets local options" do
        CabClient::Configurable::OPTIONS.each do |key|
          expect(subject.send(key)).not_to eq(CabClient.send(key))
        end
      end
    end
  end
end
