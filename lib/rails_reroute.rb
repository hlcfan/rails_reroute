module RailsReroute
  class Railtie < Rails::Railtie
    initializer "rails_reroute.initializer" do
      ActionController::Base.class_eval do
        def reroute new_route
          reroute_new_env new_route
          unlock_request
          Rails.application.call(env)
          @_response = env["action_controller.instance"].response
          @_response_body = @_response.body
        end

        def reroute_default_variables
          %w( CONTENT_TYPE CONTENT_LENGTH
              HTTPS AUTH_TYPE HTTP_COOKIE GATEWAY_INTERFACE
              PATH_INFO PATH_TRANSLATED QUERY_STRING
              REMOTE_ADDR REMOTE_HOST REMOTE_IDENT REMOTE_USER
              REQUEST_METHOD SCRIPT_NAME
              SERVER_NAME SERVER_PORT SERVER_PROTOCOL SERVER_SOFTWARE
              HTTP_TE HTTP_CONNECTION HTTP_ACCEPT_ENCODING HTTP_AKAMAI_ORIGIN_HOP HTTP_VIA HTTP_X_AKAMAI_EDGESCAPE
              HTTP_X_FORWARDED_FOR HTTP_TRUE_CLIENT_IP HTTP_HOST HTTP_CACHE_CONTROL HTTP_REFERER )
        end

        def reroute_new_env new_route
          new_paths = {"PATH_INFO" => "#{new_route}", "REQUEST_URI"=>"#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{new_route}", "REQUEST_PATH"=>"#{new_route}", 
                       "ORIGINAL_REQUEST_URI" => env["REQUEST_URI"]}
          env.keys.each { |key| env.delete(key) if !reroute_default_variables.include?(key) and !key.include?("rack") }
          env.merge! new_paths
        end

        def unlock_request
          unless Rails.application.config.allow_concurrency
            Rack::Lock.new(Rails.application).call(env) rescue ThreadError
          end
        end
      end
    end
  end
end
