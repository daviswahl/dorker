require "./builder2"
require "./head"
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

      def self.containers(b, images, ctx)
      puts "\n\n\n\n"
      puts ctx.inspect
 
        b.input(Attr{ "type" => "checkbox", 
                      "class" => "select-all", 
                      "onclick" => "Dorker.Containers.toggleDisplayAll(this)" }.modify(:containers_select_all, :true, ctx)) { text "display all?"}
        b.table({"class" => "table" }) do
          b.thead do 
            b.tr do
              b.td { text "#" }
              b.td { text "id" }
              b.td { text "image" }
              b.td { text "status" }
              b.td { text "actions" }
            end
          end
          b.tbody do
            images.each_with_index do |img,i|
              b.tr do 
                b.th({ "scope" => "row" }) { text i.to_s } 
                b.td { text img["Id"].to_s[0..10] } 
                b.td { text img["Image"].to_s  }
                b.td { text img["Status"].to_s  }
                b.td do
                  b.div(Attr{ "class": "btn-group"}) do
                    b.button(Attr{ "type": "button", 
                             "class": "btn btn-primary dropdown-toggle",
                          "data-toggle" => "dropdown",
                          "aria-haspopup" => "true",
                          "aria-expanded" => "false" }) do
                            text "Action"
                            b.span(Attr{ "class": "caret" }){}
                          end
                          b.ul(Attr{ "class": "dropdown-menu" }) do
                            b.li{ b.a(Attr{ "href": "/container/#{img["Id"]}/start"} ){ text "Start" } }
                            b.li{ b.a(Attr{ "href": "/container/#{img["Id"]}/attach"} ) { text "attach" } }
                          end
                  end
                end
              end
            end
          end
        end
      end

      def self.attach(b, id)
        b.div({"class" => "attach-container" }) {}
        b.script() do
          text "Dorker.read();"
        end
      end

      def self.yield_into(context, &blk)
        b = HTML::Builder.new
        b.doctype 
        b.html do
          b.head do
            b.script(Attr{src: "//code.jquery.com/jquery-1.11.3.min.js"}){}
            b.script(Attr{src: "//code.jquery.com/jquery-migrate-1.2.1.min.js"}){}
             b.link({ "rel" => "stylesheet",
                     "href" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" }){}

            b.link({ "rel" => "stylesheet",
                     "href" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css" }){}

            b.script({ "src" => "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"}){}
            b.link({"rel" => "stylesheet", "type"=>"text/css", "href"=>"/public/dorker.css"}){}
           
            b.script({"src" =>"/public/dorker.js"}){}
          end 
          b.body do
            b.div({"class" => "container"}) do
              Dorker::HTML::Head.head(b, context)
              yield(b)
            end
          end
        end
      end
    end
  end
end


