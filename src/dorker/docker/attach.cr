class UnbufferedChannel2(T) < UnbufferedChannel(T)
  def send(value : T)
   puts "trying to send"
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
  def close
    puts "closing"
    @closed = true
    Scheduler.enqueue @receivers
    @receivers.clear
  end
  def closed?
    puts "checking if closed"
    @closed
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
  @@close_procs = {} of String => Bool

  def self.channel_hash
    @@channel_hash 
  end

  def self.close_procs
    @@close_procs
  end

  def self.client
    Dorker::Docker::SocketClient.new("/var/run/docker.sock")
  end

  def self.attach(id)
    stream = client.stream("/containers/#{id}/attach", {  "stdout" : "1", "stream" : "1" })
    channel = UnbufferedChannel(String).new
    channel_hash[id] = Array(String).new
    fiber = Fiber.new do
      loop do 
        sleep 1
        if @@close_procs[id]
          puts "brekaing fiber"
          stream.close
          break
        end
        channel.send stream.read_line 
       end
    end

    fiber2 = Fiber.new do
      loop do
        if @@close_procs[id]
          puts "brekaing fiber"
          channel_hash.delete(id)
          break
        end
        channel_hash[id] << channel.receive
        sleep 1
      end
    end

    @@close_procs[id] = false
    Scheduler.enqueue [fiber, fiber2]
  end

  def self.detach(id)
    @@close_procs[id] = true
  end

  def self.read(id)
    return [""] if !channel_hash[id]?
    ary = [] of String
    while line = channel_hash[id].shift?
     ary << line
    end
    ary
  end
   
  def self.active_attachments
    channel_hash.keys
  end

  def self.active_attachments?
    channel_hash.keys.count > 0
  end
end
