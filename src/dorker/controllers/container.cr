class Dorker::Controllers::Containers < Dorker::Controller
  endpoints :index
  PATH = /\/containers(?:\/?(?:(\w*)))?$/

  def active
    :containers
  end
  action Index, GET do
    render(:body) do |b| 
      c = Dorker::Docker::Resources::Containers.json
      Dorker::HTML::Body.containers(b,c)
    end
  end
  #def respond(m : INDEX, resp : GET) 
 #end

  def post
  end
end
  
class Dorker::Controllers::Container < Dorker::Controller
  PATH = /\/container\/(?<id>\w*)(?:\/(?<method>\w*))?$/
  endpoints(:attach) 

  action Attach, GET do |thing|
    puts "got #{thing}"
  end

  def respond(resp : GET)
    puts "got"
  end
end
