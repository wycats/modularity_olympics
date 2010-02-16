$:.push File.dirname(__FILE__) + "/lib"

require "queryer"

configured_builder = Queryer::Builder.configure(Queryer::QueryMaker.new) do
  use Queryer::Memoizing
  use Queryer::Timeout, 1.1
  use Queryer::StatsCollector, Stats.new
end

forward = configured_builder.build
backward = configured_builder.dup.reverse!.build

[forward, backward].each do |direction|
  client = Queryer::Client.new(ConnectionPool.new(20), direction)

  client.transaction do |t|
    t.select("SELECT ... FROM ... FOR UPDATE ...")
    t.execute("INSERT ...")
    t.execute("INSERT ...")
  end
  puts
end