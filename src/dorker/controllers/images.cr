class Dorker::Controllers::Images < Dorker::Controller
  PATH = /^\/images.*$/
  define_rest_endpoints(:get) 
  def get
    render(:body) do |b|
      Dorker::HTML::Body.images(b, Dorker::Docker::Resources::Images.new.json.get({ all: true}))
    end
  end
end
