class Dorker::Controllers::Images < Dorker::Controller
  endpoints :index
  PATH = /^\/images\/?(.*)$/
  def respond(resp)
    render(:body) do |b|
  #    Dorker::HTML::Body.images(b, Dorker::Docker::Resources::Images.new.json.get({ all: true}))
    end
  end
end
