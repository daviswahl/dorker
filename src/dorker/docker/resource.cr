abstract class Resource

  abstract def self.component : String

  def route
  	"/" + self.class.component
  end

  def self.add_paths

  end

  macro resource(component, &block)

  class {{component.id.capitalize}} < Resource

  	@@component = {{component}}

  	def self.component
  		@@component
  	end

  	getter :parent

  	{% if component.is_a?(SymbolLiteral) %}

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
