class Dorker::Controllers::Container < Dorker::Controller
  PATH = /\/containers/

  define_rest_endpoints(:get, :post)


  def get
    Dorker::Docker::Resources::Containers.new.json.get({ all: true})
  end

  def post
  end
end
