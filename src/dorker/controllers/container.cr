class Dorker::Controllers::Container < Dorker::Controller
  PATH = /\/containers\/?(?:(\w*)\/?(\w*))?/

  def active
    :containers
  end
  def respond(resp : GET.class) 
    render(:body) do |b| 
      c = Dorker::Docker::Resources::Containers.json
      Dorker::HTML::Body.containers(b,c)
    end
  end

  def post
  end
end
