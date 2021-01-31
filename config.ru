require 'rack'

SHOW = -> {
  puts "RackDemo instance count", ObjectSpace.each_object(RackDemo).count
  puts "MyMiddleware instance count", ObjectSpace.each_object(MyMiddleware).count
 }

class MyMiddleware
  def initialize(app, options = {})
    "MyMiddleware is initilized"
    p options
    @app = app
  end

  def call(env)
    p "MyMiddleware object_id", self.object_id
    dup._call(env)
  end

  def _call(env)
    p env
    p "duped MyMiddleware object_id", self.object_id
    @app.call(env)
  end
end

class RackDemo
  def call(env)
    SHOW.()

    [200, {"Content-Type" => "text/plain"}, ["yay"]]
  end
end

SHOW.()

use MyMiddleware, { value: 'from use' }
run RackDemo.new

SHOW.()
