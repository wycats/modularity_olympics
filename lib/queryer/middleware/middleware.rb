class Queryer
  class StatsCollector < Middleware
    def initialize(queryer, stats)
      super(queryer)
      @stats = stats
    end

    def delegate(method, env)
      @stats.measure(method) { super }
    end
  end

  class Timeout < Middleware
    def initialize(queryer, timeout)
      super(queryer)
      @timeout = timeout
    end

    def delegate(method, env)
      result = ::Timeout.timeout(@timeout) { super }
      puts "Did not timeout! Yay fast database!"
      result
    end
  end

  class Memoizing < Middleware
    class QueryFactory
      @memo = {}
      def self.for(query)
        @memo[query] ||= new(query)
      end

      def initialize(query)
        @query = query
        @memo  = {}
      end

      def new(conn, query_string)
        @memo[[conn, query_string]] ||= begin
          puts "Instantiating Query Object"
          @query.new(conn, query_string)
        end
      end
    end

    def initialize(queryer)
      super(queryer)
      @wrap_memo = {}
    end

    def delegate(method, env)
      env["nk.query"] = Memoizing::QueryFactory.for(env["nk.query"])
      super
    end
  end
end