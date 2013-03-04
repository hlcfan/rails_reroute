module RailsReroute
  class Railtie < Rails::Railtie
    initializer "rails_reroute.initializer" do
      puts "DEAR FREAKING GOD"
      ActionController::Base.class_eval do
        def reroute new_route
          new_paths = {"PATH_INFO" => "#{new_route}", "REQUEST_URI"=>"#{env["rack.url_scheme"]}://#{env["HTTP_HOST"]}#{new_route}", "REQUEST_PATH"=>"#{new_route}"}
          env.keys.each_with_index do |key,idx|
            env.delete(key) if idx > 29
          end
          env.merge! new_paths
          unlock_request
          Rails.application.call(env)
          @_response = env["action_controller.instance"].response
          @_response_body = @_response.body
        end

        def unlock_request
          Rails.application.app.instance_eval do
            if @app.kind_of? Rack::Lock
              @app.instance_eval do
                @mutex.unlock
              end
            end
          end
        end
      end
    end
  end

  class Blarg
    def self.speak
      puts "BLARG"
    end
  end
end
