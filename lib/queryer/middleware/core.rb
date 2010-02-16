require "timeout"

class Queryer
  class Middleware
    def initialize(queryer)
      @queryer = queryer
    end

    def select(env)
      delegate(:select, env)
    end

    def execute(env)
      delegate(:execute, env)
    end

    def delegate(method, env)
      @queryer.send(method, env)
    end
  end
end