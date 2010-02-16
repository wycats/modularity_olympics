require "queryer/vendor/foundation"
require "queryer/client"
require "queryer/middleware/builder"
require "queryer/middleware/core"
require "queryer/middleware/middleware"

class Queryer
  class QueryMaker
    def select(env)
      env["nk.query"].new(env["nk.connection"], env["nk.query_string"]).select
    end

    def execute(env)
      env["nk.query"].new(env["nk.connection"], env["nk.query_string"]).execute
    end
  end
end