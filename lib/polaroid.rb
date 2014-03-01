class Polaroid < Module

  VERSION = "0.0.1"

  def initialize(*messages)
    @messages = messages
    @polaroid_struct_class = ImmutableStruct.new(*messages)
    define_capture_method
    freeze
  end

  # Build the fake class for internal use in the including class' namespace.
  def included(base)
    base.const_set(:Snapshot, @polaroid_struct_class)
    base.extend(ClassMethods)
  end


private #######################################################################

  # Give the class a #take_snapshot instance method, which records the result
  # of sending an instance the assigned messages, and returns them as a Hash.
  def define_capture_method
    messages = @messages
    take_snapshot = ->(format = :hash) {
      snapshot = self.class::Snapshot.new(*(messages.map { |msg| self.send(msg) })).to_h
      format == :json ? snapshot.to_json : snapshot
    }
    define_method(:take_snapshot, &take_snapshot)
  end


  module ClassMethods
    def build_from_snapshot(snapshot_hash, format = :hash)
      case from
      when :hash
        # This line intentionally left blank
      when :json
        snapshot_hash = JSON.parse(snapshot_hash)
      end
      self::Snapshot.new(snapshot_hash)
    end
  end

end
