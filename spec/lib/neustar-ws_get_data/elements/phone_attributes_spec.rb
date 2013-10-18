require 'spec_helper'

module Neustar::WsGetData
  describe PhoneAttributes do
    let(:client) { double("mock client") }

    describe "query" do
      it "should query client with correct element ID" do
        client.should_receive(:query).with(hash_including(:elements => {:id => 1320}))

        PhoneAttributes.query(client, '55555555555')
      end
    end
  end
end
