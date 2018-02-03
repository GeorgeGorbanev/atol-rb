require 'atol/request/get_document_state'
require 'atol/errors'

module Atol
  module Transaction
    class GetDocumentState
      def initialize(uuid:, token:, config: nil)
        @config = config || Atol.config
        raise(Atol::ConfigExpectedError) unless @config.is_a?(Atol::Config)
        @params = Hash[uuid: uuid, token: token, config: @config]
      end

      def call
        request = Atol::Request::GetDocumentState.new(params)
        response = request.call
        encoded_body = response.body.force_encoding(Atol::ENCODING)
        json = JSON.parse(encoded_body)

        if response.code == '200' && json['error'].nil?
          json
        elsif Atol::ERRORS[json['error']['code']]
          raise(Atol::ERRORS[json['error']['code']], encoded_body)
        else
          raise(encoded_body)
        end
      end

      private

      attr_reader :params
    end
  end
end