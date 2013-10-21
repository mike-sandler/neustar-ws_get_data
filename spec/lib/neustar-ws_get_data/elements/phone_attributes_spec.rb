require 'spec_helper'

module Neustar::WsGetData
  describe PhoneAttributes do
    let(:client) { double("mock client") }
    let(:phone_number) { '5555555555' }

    describe "query" do
      it "should send client and parameterized options to execute_request" do
        expected_params = hash_including(:phone_number => phone_number, :indicators => '1,2,3,4')
        raw_response = "mock raw response"
        response = "mock processed response"

        PhoneAttributes.should_receive(:execute_request).with(client, expected_params).and_return(raw_response)
        PhoneAttributes.should_receive(:process_response).with(raw_response, expected_params).and_return(response)
        PhoneAttributes.query(client, phone_number).should == response
      end
    end

    describe "execute_request" do
      it "should execute query on client with correctly assembled parameters" do
        indicators = "2,3"

        client.should_receive(:query).with({
          :elements => { :id => 1320 },
          :serviceKeys => {
            :serviceKey => [
              {
                :id    => 1,
                :value => phone_number
              },
              {
                :id    => 599,
                :value => indicators
              }
            ]
          }
        })

        PhoneAttributes.execute_request(client, :phone_number => phone_number, :indicators => indicators)
      end
    end

    describe "process_response" do
      it "should raise OutOfDomainError" do
        raw_response = {:error_code => PhoneAttributes::OUT_OF_DOMAIN_ERROR}
        expect {
          PhoneAttributes.process_response(raw_response, :phone_number => phone_number)
        }.to raise_error(PhoneAttributes::OutOfDomainError, phone_number)
      end

      it "should parse out responses from each category" do
        raw_response = {:result => { :element => { :value => "N,D,I2,W" } } }
        response = PhoneAttributes.process_response(raw_response, :phone_number => phone_number)
        response.should == {
          :prepaid_phone    => false,
          :business_phone   => :dual_phone,
          :phone_in_service => "Inactive for 2 months",
          :phone_type       => :wireless
        }
      end
    end

    describe "parse_indicators" do
      it "should return all indicators if none are supplied" do
        PhoneAttributes.parse_indicators([]).should == "1,2,3,4"
      end

      it "should return correct individual mappings" do
        PhoneAttributes.parse_indicators([:prepaid_phone]).should == "1"
        PhoneAttributes.parse_indicators([:business_phone]).should == "2"
        PhoneAttributes.parse_indicators([:phone_in_service]).should == "3"
        PhoneAttributes.parse_indicators([:phone_type]).should == "4"
      end

      it "should combine mappings" do
        PhoneAttributes.parse_indicators([:prepaid_phone, :business_phone]).should == "1,2"
        PhoneAttributes.parse_indicators([:business_phone, :phone_in_service, :phone_type]).should == "2,3,4"
      end
    end
  end
end
        #client.should_receive(:query).with(hash_including(:elements => {:id => 1320}))
