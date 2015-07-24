class Dorker::Controllers::Containers < Dorker::Controller
  endpoints :index
  PATH = /\/containers(?:\/?(?:(\w*)))?$/

  def active
    :containers
  end
  action Index, GET do
    json = {} of String => String
    select = @params["display_all"]?.try &.first

    @context.active_tab = :containers
    @context.active_attachment = nil
    @context.containers_select_all = select ? select == "true" : false
 
    Attr.modifier(:containers_select_all) do |attr, args, ctx|
     ctx.containers_select_all ? attr.append_attr("properties", "checked") : attr
    end

    render(:body) do |b| 
      json.merge!({"all" => select}) if select
      c = Dorker::Docker::Resources::Containers.json(json)
      Dorker::HTML::Body.containers(b,c,@context)
    end
  end
end
  
class Dorker::Controllers::Container < Dorker::Controller
  PATH = /\/container\/(?<id>\w*)(?:\/(?<method>\w*))?$/
  endpoints(:attach, :read, :start, :show)
  
  action Start, GET do |id|
    Dorker::Docker::Resources::Containers.new(id)
  end

  action Show, GET do |id|

    @context.active_attachment = id    

    Attr.modifier(:active_attachment) do |attr, args, ctx|
      ctx.active_attachment == args ? attr.append_attr(:class, "active") : attr
    end

    render(:body) do |b|
      Dorker::HTML::Body.attach(b, id)
    end
  end


  action Attach, GET do |id|
    h = Dorker::Docker::Resources::Containers.new(id)
    h.attach
    @context.active_attachment = id    
    Attr.modifier(:active_attachment) do |attr, args, ctx|
      ctx.active_attachment == args ? attr.append_attr(:class, "active") : attr
    end

    render(:body) do |b|
      Dorker::HTML::Body.attach(b, id)
    end
  end

  action Read, GET do |id|
    h = Dorker::Docker::Resources::Containers.new(id)
    headers.add("Content-type", "application/json")
    @body = { "resp" : h.read_attach }.to_json
  end
end
