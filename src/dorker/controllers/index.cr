class Dorker::Controllers::Index < Dorker::Controller
  PATH = "/"
  define_rest_endpoints(:get, :post)

  def get
    render(:body) do
       
    end
  end

  def post

  end
end
