require "./builder2"
module Dorker
  module HTML
    module Body

      def self.head(builder)
        builder.ul( {"class" => "nav nav-tabs"}) do 
          builder.li( { "role" => "presentation", "class" => "active" } ) do
            builder.a({ "href" => "/images"}) { text("images") }
          end
          builder.li( { "role" => "presentation" } ) do
            builder.a({ "href" =>  "/containers"}) { text("containers") }
          end
        end
      end
      def self.yield_into(&blk) 
        builder = HTML::Builder.new
        builder.doctype 
        builder.html do
          builder.head do
            builder.link({ "rel" => "stylesheet",
                          "href" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" }){}

            builder.link({ "rel" => "stylesheet",
                          "href" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css" }){}

            builder.script({ "src" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"}){}
            builder.link({"rel" => "stylesheet", "type"=>"text/css", "href"=>"public/dorker.css"}){}
          end 
          builder.body do
            builder.div({"class" => "container"}) do
              head(builder)
              yield(builder)
            end
          end
      end
      end
    end
  end
end


