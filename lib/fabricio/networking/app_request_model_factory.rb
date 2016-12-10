require 'fabricio/networking/request_model'
require 'fabricio/authorization/authorization_signer'

module Fabricio
  module Networking
    class AppRequestModelFactory
      include Fabricio::Authorization::AuthorizationSigner

      FABRIC_API_URL = 'https://fabric.io'
      FABRIC_INSTANT_API_URL = 'https://instant.fabric.io'
      FABRIC_API_PATH = '/api/v2'
      FABRIC_APPS_ENDPOINT = '/apps'
      FABRIC_ORGANIZATIONS_ENDPOINT = '/organizations'

      def all_apps_request_model(session)
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_API_URL,
                                                       FABRIC_API_PATH + FABRIC_APPS_ENDPOINT)
        sign_request_model(model, session)
        model
      end

      def get_app_request_model(session, app_id)
        path = "#{FABRIC_API_PATH}#{app_endpoint(app_id)}"
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_API_URL,
                                                       path)
        sign_request_model(model, session)
        model
      end

      def active_now_request_model(session, app_id)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('active_now')}"
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path)
        sign_request_model(model, session)
        model
      end

      def daily_new_request_model(session, app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('daily_new')}"
        headers = {
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path,
                                                       headers)
        sign_request_model(model, session)
        model
      end

      def daily_active_request_model(session, app_id, start_time, end_time)
        path = "#{FABRIC_API_PATH}#{org_app_endpoint(session, app_id)}#{growth_analytics_endpoint('daily_active')}"
        headers = {
            'start' => start_time,
            'end' => end_time
        }
        model = Fabricio::Networking::RequestModel.new(:GET,
                                                       FABRIC_INSTANT_API_URL,
                                                       path,
                                                       headers)
        sign_request_model(model, session)
        model
      end

      private

      def app_endpoint(app_id)
        "/#{FABRIC_APPS_ENDPOINT}/#{app_id}"
      end

      def org_endpoint(session)
        "/#{FABRIC_ORGANIZATIONS_ENDPOINT}/#{session.organization_id}"
      end

      def org_app_endpoint(session, app_id)
        "#{org_endpoint(session)}/#{app_endpoint(app_id)}"
      end

      def growth_analytics_endpoint(name)
        "/growth_analytics/#{name}.json"
      end
    end
  end
end
