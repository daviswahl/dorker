class Dorker::Controllers::Index < Dorker::Controller
  PATH = /^\/$/

  def respond(resp : GET.class)
    render(:body) do |body|
      body.a do
        text("asdf")
      end
    end
  end

  def post

  end
end
