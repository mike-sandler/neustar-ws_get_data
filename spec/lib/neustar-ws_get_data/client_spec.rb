require 'spec_helper'

module Neustar::WsGetData
  describe Client do
    let(:credentials) { {:username => 'foo', :password => 'bar', :service_id => 123} }
    let(:client) { Client.new(credentials) }
    let(:savon_client) { double('Savon Client') }
    let(:service)  { :query }

    let(:successful_response) { double(Savon::Response, :body => body) }
    let(:body) do
      {
        :query_response => {
          :response => {
            :trans_id => "12345",
            :error_code => "0",
            :error_value => nil,
            :result => {
              :element => {
                :id => "1320",
                :error_code => "0",
                :value => "N,U,A1,W"
              }
            }
          },
         :@xmlns=>"http://TARGUSinfo.com/WS-GetData"
        }
      }
    end

    before do
      Savon.stub(:client).and_return(savon_client)
    end

    describe "operations" do
      it "should fetch available operations from savon" do
        operations = [:super, :duper]

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
      it "should execute call on savon client and process response" do
        result = "mock result"

        savon_client.
          should_receive(:call).
          with(service, hash_including(:message => anything)).
          and_return(successful_response)

        client.should_receive(:process_response).with(service, successful_response).and_return(result)
        client.call(service, {}).should == result
      end

      it "should re-raise Savon::SOAPFault as native exception" do
        savon_client.
          should_receive(:call).
          and_raise(soap_fault)

        expect {
          client.call(service, {})
        }.to raise_error(Neustar::Error, "Access Violation - Invalid Origination")
      end
    end

    describe "process_response" do
      it "should extract base query response" do
        client.process_response(:query, successful_response).should == \
        {
          :trans_id => "12345",
          :error_code => "0",
          :error_value => nil,
          :result => {
            :element => {
              :id => "1320",
              :error_code => "0",
              :value => "N,U,A1,W"
            }
          }
        }
      end
    end

    describe "origination_params" do
      it "should set username and password in origination field" do
        params = client.origination_params
        params[:serviceId].should == "123"

        origination = params[:origination]
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
