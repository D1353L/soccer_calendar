require 'haml'

# Racker
class Racker
  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when '/' then index
    else not_found
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    Haml::Engine.new(File.read(path)).render
  end

  def index
    Rack::Response.new(render('index.html.haml'))
  end

  def not_found
    Rack::Response.new('Not Found', 404)
  end
end
