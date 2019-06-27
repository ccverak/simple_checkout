# frozen_string_literal: true

require "spec_helper"
require "http"

RSpec.describe CabClient::Response do
  describe "#json" do
    subject do
      CabClient::Response.new(HTTP::Response.new(
                                version: "1.1",
                                status: 201,
                                connection: double,
                                body: { "foo": "bar" }.to_json,
                              ))
    end

    it "returns response parsed body" do
      expect(subject.json).to eq("foo" => "bar")
    end
  end

  describe "#success" do
    subject do
      CabClient::Response.new(HTTP::Response.new(
                                version: "1.1",
                                status: 200,
                                connection: double,
                              ))
    end

    it { expect(subject.status).to be_success }
  end

  describe "#created?" do
    subject do
      CabClient::Response.new(HTTP::Response.new(
                                version: "1.1",
                                status: 201,
                                connection: double,
                              ))
    end

    it { expect(subject.status).to be_created }
  end

  describe "#not_found?" do
    subject do
      CabClient::Response.new(HTTP::Response.new(
                                version: "1.1",
                                status: 404,
                                connection: double,
                              ))
    end

    it { expect(subject.status).to be_not_found }
  end

  describe "#request_timeout?" do
    subject do
      CabClient::Response.new(HTTP::Response.new(
                                version: "1.1",
                                status: 408,
                                connection: double,
                              ))
    end

    it { expect(subject.status).to be_request_timeout }
  end

  describe "#server_error?" do
    subject do
      CabClient::Response.new(HTTP::Response.new(
                                version: "1.1",
                                status: 500,
                                connection: double,
                              ))
    end

    it { expect(subject.status).to be_server_error }
  end
end
