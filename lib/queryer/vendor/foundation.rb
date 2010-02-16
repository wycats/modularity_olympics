require "benchmark"

# This code was mostly provided by Nick for the challenge. I'm using it 
# unaltered here, as though it was an external library

class ConnectionPool
  def initialize(size)
    @size = size
  end
 
  def with_connection
    yield Object.new
  end
end
 
class Stats
  def measure(name)
    result = nil
    bm = Benchmark.measure { result = yield }
    puts "Measured #{name} at #{"%.2f" % bm.real} seconds"
    result
  end
end
 
class Query
  def initialize(connection, query_string, *args)
    @connection = connection
    @query_string = query_string
    @args = args
  end
 
  def select
    sleep 1
    puts "Selecting #{@query_string} on #{@connection}"
    [1, 2, 3]
  end
 
  def execute
    sleep 1
    puts "Executing #{@query_string} on #{@connection}"
    1
  end
end
