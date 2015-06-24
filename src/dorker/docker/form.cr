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
    macro define_more(t)
      puts t
    end

    macro define_endpoint(endpoint, methods, block)
     module {{endpoint.capitalize.id}}
        {% for method in methods %}
        {{block}}.call(RestMethod.parse({{method.upcase}}.to_s))
        def self.{{method.id}}
          meth = Dorker::Docker::Form::RestMethod.parse({{method.id}})
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
