class Dorker::Docker::Forms::Containers < Dorker::Docker::Form
  PATH = "/containers/json"
  define_endpoint(:index, [:get, :post], ->(msg : RestMethod) { puts msg })
end
