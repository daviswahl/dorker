class Dorker::Docker::Forms::Containers < Dorker::Docker::Form
  id_component(container)
  resource("/container", nil) do |container|
    resource("/id", container) do |id|
      resource("/json", id) do |json|
      end

      resource("/top", id) do |top|
      end

    end
  end
end
