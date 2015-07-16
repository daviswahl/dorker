class Resource
  getter component
  getter parent
  def id(&id)
   @id = id
  end

  def id : String | Nil
    @id.call || false
  end

  def route
    p = @parent
    if p
    "#{p.route}#{format_component}"
    else
      format_component
    end
  end

  def format_component
   @id.call
  end

  def children
    @children ||= [] of Resource
  end

  def initialize(component, parent = nil, &block : Resource -> )
    @id = ->() { "" }
    @component = component
    @parent = parent
    yield(self) if block
  end

  def root
    p = @parent
    @root = if p
      p.root
    else
      self
    end
  end
end

macro id_component(component)
 def {{component}}_id
   @{{component.id}}_id
 end

 def set_{{component.id}}_id(id)
   @{{component.id}}_id = id
 end
end

macro resource(component, parent = nil, &block)
 r = {% if block %}
   Resource.new({{component}}, {{parent}}) {{block}}
 {% else %}
   Resource.new({{component}}, {{parent}})
 {% end %}
 {% if !parent %}
   @@root=r
 {% else %}
   {{parent}}.children << (r)
 {% end %}
end

  class Dorker::Docker::Form
    def self.root
      @@root
    end
  end
