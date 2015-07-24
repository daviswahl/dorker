

class Dorker::Controllers::Public < Dorker::Controller
  PATH = /^\/public\/(.*)$/
  endpoints(:index)
  action Index, GET do 
    path = @request.path
    if path
      path = "/home/rdu/dwahl/gits/dorker" + path
      if File.exists?(path)
        @body = File.open(path, "r").read
        headers.add("Content-type", "text/css")
      else
        raise Exception.new("File does not exist")
      end
    else
      raise Exception.new("File does not exist")
    end
  end

end
