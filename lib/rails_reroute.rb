require 'default_variables'

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

        def reroute_new_env new_route
          new_paths = {
            "PATH_INFO" => "#{new_route}",
            "REQUEST_URI"=>"#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{new_route}",
            "REQUEST_PATH"=>"#{new_route}", 
            "ORIGINAL_REQUEST_URI" => env["REQUEST_URI"]
          }

          env.select! do |key, value|
            DEFAULT_VARIABLES.include?(key) || key.include?("rack")
          end

          env.merge! new_paths
        end

        def unlock_request
          unless Rails.application.config.allow_concurrency
            if Rails.application.config.action_controller.perform_caching
              mutex = Rails.application.app.instance_variable_get("@backend").instance_variable_get("@mutex")
            else
              mutex = Rails.application.app.instance_variable_get("@app").instance_variable_get("@mutex")
            end

            mutex.unlock if mutex.locked?
          end
        end
      end
    end
  end
end
