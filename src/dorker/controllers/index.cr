class Dorker::Controllers::Index < Dorker::Controller
  PATH = /^\/$/
  endpoints :index
  def respond(resp)
    render(:body) do |body|
      body.a do
        text("asdf")
      end
    end
  end

  def post

  end
end
