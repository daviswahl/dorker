abstract
  class Dorker::Docker::Form
    enum RestMethod
    GET
    POST
    PUT
    end
    macro inherited
       Dorker::Docker::Client.endpoints[:{{@type.id.split("::").last.downcase.id}}] = {{@type.name}}
    end

    macro define_endpoint(endpoint, *methods)
     module {{endpoint.capitalize.id}}
       {% for method in {{methods}} %}
        def self.{{method.id}}
          client.{{method.id}}({{PATH}})
        end

        def self.{{method.id}}
          client.{{method.id}}({{PATH}}) { |headers, body, query| yield(headers, body, query) }
        end
       {% end %}
        def self.client
          Dorker::Docker.client
        end
      end

      def {{endpoint.id}}
        {{endpoint.capitalize.id}}
      end
    end
end
