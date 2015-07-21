class Dorker::Controllers::Images < Dorker::Controller
  PATH = /^\/images.*$/
  define_rest_endpoints(:get) 
  def get
    render(:body) do |b|
      b.div do 
        text(Dorker::Docker::Resources::Images.new.json.get({ all: true}).first.to_s)
      end
    end
  end
end
