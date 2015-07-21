class Dorker::Controllers::Container < Dorker::Controller
  PATH = /\/containers/

  define_rest_endpoints(:get, :post)

  def get
    render(:body) { }
    render(:content) { "application/json" }
  end

  def post
  end
end
