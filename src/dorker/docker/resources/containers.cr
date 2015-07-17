class Dorker::Docker::Resources::Containers < ClientResource
 def self.component
   "containers"
 end

 has_client Dorker::Docker::SocketClient.new("/var/run/docker.sock")

 resource(:id) do
   resource("json") do
   end

   resource("top") do
     get() do |resp|
       puts resp.body
     end
   end
 end
end
