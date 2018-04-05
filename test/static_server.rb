require "webrick/httpserver"

module StaticServer
  def self.start(directory, port)
    server = WEBrick::HTTPServer.new(
        AccessLog: [],
        BindAddress: 'localhost',
        Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
        Port: port,
        DocumentRoot: __dir__ + "/../#{directory}"
    )
    Thread.new do
      server.start
    end
    server
  end
end
