require "./builder2"
module Dorker
  module HTML
    module Body
      def self.images(b, images)
        b.table({"class" => "table" }) do
          b.thead do 
            b.tr do
             b.td { text "#" }
             b.td { text "id" }
             b.td { text "label" }
             b.td { text "created" }
            end
          end
          b.tbody do
            images.each_with_index do |img,i|
              b.tr do 
                b.th({ "scope" => "row" }) { text i.to_s } 
                b.td { text img.id.to_s } 
                b.td { text img.labels.to_s }
                b.td { text img.created.to_s  }
              end
            end
          end
        end
      end
      def self.head(b)
        b.ul( {"class" => "nav nav-tabs"}) do 
          b.li( { "role" => "presentation", "class" => "active" } ) do
            b.a({ "href" => "/images"}) { text("images") }
          end
          b.li( { "role" => "presentation" } ) do
            b.a({ "href" =>  "/containers"}) { text("containers") }
          end
        end
      end
      def self.yield_into(&blk) 
        b = HTML::Builder.new
        b.doctype 
        b.html do
          b.head do
            b.link({ "rel" => "stylesheet",
                          "href" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" }){}

            b.link({ "rel" => "stylesheet",
                          "href" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css" }){}

            b.script({ "src" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"}){}
            b.link({"rel" => "stylesheet", "type"=>"text/css", "href"=>"public/dorker.css"}){}
          end 
          b.body do
            b.div({"class" => "container"}) do
              head(b)
              yield(b)
            end
          end
      end
      end
    end
  end
end


