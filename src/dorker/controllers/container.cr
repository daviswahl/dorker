class Dorker::Controllers::Container < Dorker::Controller
  PATH = /\/containers/

  def active
    :containers
  end
  def respond(resp : GET.class) 
    render(:body) do |b| 
    Dorker::HTML::Body.containers(b, Dorker::Docker::Resources::Containers.new.json.get({ all: true}))
    end
  end

  def post
  end
end
