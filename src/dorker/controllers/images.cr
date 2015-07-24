class Dorker::Controllers::Images < Dorker::Controller
  PATH = /^\/images\/?(.*)$/
  def respond(resp : GET.class)
    render(:body) do |b|
  #    Dorker::HTML::Body.images(b, Dorker::Docker::Resources::Images.new.json.get({ all: true}))
    end
  end
end
