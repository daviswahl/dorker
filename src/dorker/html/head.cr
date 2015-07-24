require "./builder2"
module Dorker
  module HTML
    module Head
      def self.head(b, context)
        b.ul( Attr{class: "nav nav-tabs"}) do 
          b.li( Attr{ role: "presentation" }.modify(:active_tab, :images, context) ) do
            b.a({ "href" => "/images"}){ text "images" }
          end
          b.li( Attr{ role: "presentation" }.modify(:active_tab, :containers, context)) do
            b.a( Attr{ href:  "/containers" }) { text("containers") }
          end
        end
        attachments(b,context) if Dorker::Docker::Attach.active_attachments?
      end

      def self.attachments(b, context)
        b.ul( Attr{class: "nav nav-tabs"}) do 
          Dorker::Docker::Attach.active_attachments.each do |atch|
            b.li( Attr{ role: "presentation" }.modify(:active_attachment, atch, context) ) do
              b.a( Attr{ href:  "/container/#{atch}/show" }) { text(atch[0..10]) }
            end
          end
        end
      end
    end
  end
end

