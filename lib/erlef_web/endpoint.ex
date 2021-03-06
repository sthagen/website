defmodule ErlefWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :erlef

  # max age is thirty days
  @session_options [
    store: :cookie,
    key: "_erlef_key",
    max_age: 60 * 60 * 24 * 30,
    secure: true,
    serializer: Erlef.Session,
    encryption_salt: "41SM3UP3NgSUTzLOqCqF0r2pJBn54JuOy9+cZswJuiQi5pnCIIwJfEYO7DP3/QqR",
    signing_salt: "pSnWMnUh"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :erlef,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt manifest.json)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Logger

  # Note: This must be disabled if we switch to an env where there is no reverse proxy in front of this
  # app.
  if Erlef.is_env?(:prod) do
    plug Plug.RewriteOn, [:x_forwarded_host, :x_forwarded_port, :x_forwarded_proto]
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options

  plug ErlefWeb.Router
end
