module TransferWise
  class APIResource
    include TransferWise::TransferWiseObject

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.resource_url(resource_id)
      "#{collection_url}/#{resource_id}"
    end

    def self.collection_url(resource_id = nil)
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class. You should perform actions on its subclasses (Account, Transfer, etc.)')
      end

      case class_name.downcase
      when 'user'
        '/v1/user/signup/registration_code'
      when 'fund'
        "/v1/transfers/#{resource_id}/payments"
      else
        "/v1/#{CGI.escape(class_name.downcase)}s"
      end
    end

    def self.create(params={}, opts={})
      resource_id = params.delete(:id)

      url = resource_id.nil? ? collection_url : collection_url(resource_id)

      response = TransferWise::Request.request(:post, url, params, opts)
      convert_to_transfer_wise_object(response)
    end

    def self.list(filters = {}, headers = {})
      response = TransferWise::Request.request(:get, collection_url, filters, headers)
      convert_to_transfer_wise_object(response)
    end

    def self.get(resource_id, headers = {})
      response = TransferWise::Request.request(:get, resource_url(resource_id), {}, headers)
      convert_to_transfer_wise_object(response)
    end
  end
end
