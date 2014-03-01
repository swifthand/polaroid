class Polaroid < Module

  VERSION = "0.0.1"

  def initialize(*messages)
    @messages = messages
    @polaroid_struct_class = ImmutableStruct.new(*messages)
    define_capture_method
    freeze
  end


  def included(base)
    base.const_set(:Snapshot, @polaroid_struct_class)
    base.extend(ClassMethods)
  end


private #######################################################################

  def define_capture_method
    messages = @messages
    define_method(:take_snapshot) do
      self.class::Snapshot.new(*(messages.map { |msg| self.send(msg) })).to_h
    end
  end

  module ClassMethods
    def build_from_snapshot(snapshot_hash)
      self::Snapshot.new(snapshot_hash)
    end
  end

end
