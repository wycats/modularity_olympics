class Queryer
  class AlternateStatsCollector < Middleware
    def delegate(method, env)
      env["stats.instance"].measure(method) { super }
    end
  end

  class AlternateTimeout < Middleware
    def delegate(method, env)
      result = ::Timeout.timeout(env["timeout.duration"]) { super }
      puts "Did not timeout! Yay fast database!"
      result
    end
  end
end