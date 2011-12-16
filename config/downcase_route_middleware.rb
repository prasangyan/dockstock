class DowncaseRouteMiddleware
  def initialize(app)
    @app = app
  end
  def call(env)
    uri_items = env["REQUEST_URI"].split('?')
    uri_items[0].downcase!
    env["REQUEST_URI"] = uri_items.join("?")

    env["PATH_INFO"] = env["PATH_INFO"].downcase
    @app.call(env)
  end
end