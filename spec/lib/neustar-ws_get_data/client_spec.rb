require 'spec_helper'

module Neustar::WsGetData
  describe Client do
    let(:client) { Client.new('foo', 'bar') }

    describe "operations" do
      it "should fetch available operations from savon" do
        operations = [:super, :duper]

        savon_client = double('Savon Client')
        savon_client.should_receive(:operations).and_return(operations)
        Savon.should_receive(:client).and_return(savon_client)

        client.operations.should == operations
      end
    end

    describe "query" do
      it "should call with query as service" do
        options = {:foo => 'bar'}
        client.should_receive(:call).with(:query, options)

        client.query(options)
      end
    end

    describe "batch_query" do
      it "should call with batch_query as service" do
        options = {:foo => 'bar'}
        client.should_receive(:call).with(:batch_query, options)

        client.batch_query(options)
      end
    end

    describe "call" do
      let(:savon_client) { double('Savon Client') }
      let(:response) { "mock response" }
      let(:service)  { "mock service" }
      let(:params)   { {:foo => 'bar'} }

      before do
        Savon.stub(:client).and_return(savon_client)
      end

      it "should execute call on savon client" do
        savon_client.
          should_receive(:call).
          with(service, hash_including(:message => anything)).
          and_return(response)

        client.call(service, params).should == response
      end

      it "should re-raise Savon::SOAPFault as native exception" do
        fault = \
          Savon::SOAPFault.new(new_response(:body => load_fixture('fault.xml')), nori)
        
        savon_client.
          should_receive(:call).
          and_raise(fault)

        expect {
          client.call(service, params)
        }.to raise_error(Neustar::Error, "Access Violation - Invalid Origination")
      end
    end

    describe "origination_params" do
      it "should set username and password in origination field" do
        origination = client.origination_params[:origination]
        origination[:username].should == "foo"
        origination[:password].should == "bar"
      end
    end

    describe "build_transaction_id" do
      it "should generate integer identifier" do
        client.build_transaction_id.should be_a(Integer)
      end
    end
  end
end
