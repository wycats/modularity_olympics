class Queryer
  class Builder
    def self.configure(queryer, &block)
      queryer = new(queryer)
      queryer.instance_eval(&block)
      queryer
    end

    def initialize(queryer)
      @queryer = queryer
      @middlewares = []
    end

    def use(middleware, *args)
      @middlewares << [middleware, args]
    end

    def reverse!
      @middlewares = @middlewares.reverse
      self
    end

    def build
      queryer = @queryer

      @middlewares.each do |klass, args|
        queryer = klass.new(queryer, *args)
      end

      queryer
    end
  end
end