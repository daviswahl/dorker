abstract class Dorker::Resource
  abstract def self.component

  def route
  	"/" + self.class.component
  end

  macro shared_resource(component, klass, &block)

  class {{component.id.capitalize}} < {{klass}} 

  	@@component = {{component}}

  	def self.component
  		@@component
  	end

  	getter :parent

  	{% if component.is_a?(SymbolLiteral) %}

  		getter :component_id

  		def initialize(parent : Resource, component_id)
  			@parent = parent
  			@component_id = component_id
  		end

  		def route
  		  [parent.route, self.class.component, component_id].join("/")
  		end

  		def component_id
  			@component_id
  		end

    {% else %}

     	def initialize(parent : Resource);
     	  @parent = parent
     	end

     	def route
     		[parent.route, self.class.component].join("/")
     	end

    {% end %}

  	{% {{block.body}} if block %}
  end

  {% if component.is_a?(SymbolLiteral) %}

  	def {{component.id}}(arg)
  		{{component.id.capitalize}}.new(self, arg)
  	end

  {% else %}

  	def {{component.id}}
  		{{component.id.capitalize}}.new(self)
  	end

  {% end %}
  end
end

abstract class ClientResource < Dorker::Resource
 macro has_client(client)
    def client
      {{client}}
    end
  end

  def client
  	parent.client
  end

  macro resource(component, &block)
  	shared_resource({{component}}, ClientResource) do
  		{{block.body}}
  	end
  end

  macro get(&block)
     def get(params : Hash | Nil)
     	  resp = self.client.get(route)
     	  {{block.body}}
     end
   end
end
