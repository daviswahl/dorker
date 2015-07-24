require "html"
require "../../dorker/controller"
struct RenderContext
  def initialize
    @containers_select_all = false
    @active_tab = nil
    @active_attachment = nil
  end
  property :active_tab, :active_attachment, :containers_select_all
end
 
struct Attr
  @@modifiers = {} of Symbol => Attr, Symbol | String, RenderContext -> Attr

  include Enumerable(Hash(String | Symbol, String | Symbol | Int32))

  def initialize 
    @hash = {} of String | Symbol => String | Symbol | Int32 | Array(String | Symbol)
  end

  def initialize(hash)
    @hash = hash as Hash(String | Symbol, String | Symbol | Int32 | Array(String | Symbol))
  end

  def delete(key)
    @hash.delete(key)
  end

  def each 
    @hash.each do |k, v|
      yield k, v
    end
  end
  def self.[]
    new
  end
  def self.[](arg1, arg2)
    a = new
    a[arg1] = arg2
    a
  end

  protected def set(h)
    @hash = h
  end

  def new; end

  def set_attr(key, attr)
   @hash[key] = attr 
   self
  end

  def append_attr(key, attr)
    str = @hash[key]? || ""
    str = str + attr.to_s
    @hash[key] = str
    self
  end

  def [](arg1)
    @hash[arg1]
  end

  def []?(arg1)
    @hash[arg1]?
  end

  def [](arg1, arg2)
    @hash[arg1] = arg2
  end

  def []=(arg, arg2)
    @hash[arg] = arg2
    self
  end

  def self.from_hash(hash)
    h = new
    hash.each do |k, v|
     h[k] = v
    end
    h
  end

  def to_s
    hsh = {} of String => String
    @hash.each do |k,v|
      hsh[k.to_s] = v.to_s
    end
    hsh
  end

  def self.modifier(key, &block : Attr, Symbol | String, RenderContext -> Attr)
    @@modifiers[key] = block
  end

  def modify(key, arg, context)
    @@modifiers[key].call(self, arg, context)
  end
end

struct HTML::Builder
  def initialize
    @str = StringIO.new
  end

  def build
    with self yield self
    @str.to_s
  end

  {% for tag in %w(a b body button div em h1 h2 h3 head link html i img input li ol p s script span strong table tbody td textarea
   thead th title tr u ul form) %}
    def {{tag.id}}(attrs = nil : Hash? | Attr?)
      if attrs && attrs.is_a?(Hash)
        attrs = Attr.from_hash(attrs)
      end
      @str << "<{{tag.id}}"
      if attrs
        props = [attrs.delete("properties")].compact
        @str << " "
        attrs.each do |name, value|
          @str << name
          @str << %(=")
          HTML.escape(value, @str)
          @str << %(")
        end
        if props
          props.each do |p|
            @str << p
          end
        end
      end
     @str << ">"
      with self yield self
      @str << "</{{tag.id}}>"
    end
  {% end %}

  def doctype
    @str << "<!DOCTYPE html>"
  end

  def br
    @str << "<br/>"
  end

  def hr
    @str << "<hr/>"
  end

  def text(text)
    @str << HTML.escape(text)
  end
end
