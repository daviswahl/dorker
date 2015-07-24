class UnbufferedChannel2(T) < UnbufferedChannel(T)
  def send(value : T)

   while @has_value
      raise_if_closed
      @senders << Fiber.current
      Scheduler.reschedule
    end

    raise_if_closed

    @value = value
    @has_value = true
    @sender = Fiber.current
    
    if receiver = @receivers.pop?
      receiver.resume
    else
      Scheduler.reschedule
    end
  end

  private def receive_impl

    until @has_value
      yield if @closed
      @receivers << Fiber.current
      if sender = @senders.pop?
        sender.resume
      else
        Scheduler.reschedule
      end
    end

    yield if @closed

    @value.tap do
      @has_value = false
      Scheduler.enqueue @sender.not_nil!
    end
  end
end
class Dorker::Docker::Attach
  @@channel_hash = {} of String => Array(String)

  def self.channel_hash
    @@channel_hash 
  end

  def self.client
    Dorker::Docker::SocketClient.new("/var/run/docker.sock")
  end

  def self.attach(id)
    stream = client.stream("/containers/#{id}/attach", {  "stdout" : "1", "stream" : "1" })
    channel = UnbufferedChannel2(String).new
    channel_hash[id] = Array(String).new
    fiber = Fiber.new do
      loop do
        stream.each_line { |l| channel.send(l) }
        Scheduler.yield
      end
    end
    Scheduler.enqueue fiber

    fiber2 = Fiber.new do
      loop do
        channel_hash[id] << channel.receive
        Scheduler.yield
      end
    end
    Scheduler.enqueue fiber2
   end

  def self.read(id)
    ary = [] of String
    while line = channel_hash[id].shift?
     ary << line
    end
    ary
  end
end
