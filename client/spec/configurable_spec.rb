# frozen_string_literal: true

require "spec_helper"

RSpec.describe CabClient::Configurable do
  it "allows to configure token" do
    expect(
      CabClient::Configurable::OPTIONS,
    ).to eq(%i[api_base timeout])
  end

  describe ".configure" do
    described_class::OPTIONS.each do |key|
      before do
        CabClient.configure { |config| config.send("#{key}=", key) }
      end

      it "sets #{key}" do
        expect(CabClient.send(key)).to eq(key)
      end
    end
  end
end
