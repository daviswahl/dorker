class Dorker::Docker::Resources::Containers < Resource
 def self.component
   "containers"
 end

 resource(:id) do
   resource("json") do
   end

   resource("top") do
   end
 end
end
