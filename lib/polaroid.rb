require 'json'
require 'immutable_struct'

class Polaroid < Module

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
    ##
    # This method will try its damnedest to give you a meaningful snapshot object,
    # but first it needs to somehow get it into a Hash. Either you can let it autodetect
    # and give it a Hash-like, JSON String-like, or something which responds to #to_h or #to_s,
    # or you can explicitly pass it the format as :hash or :json.
    def build_from_snapshot(snapshot, format = :auto)
      symbolize_keys  = ->((key, val), hash) { hash[key.to_sym] = val }
      from_hash       = ->(snap) { snap.each.with_object({}, &symbolize_keys) }
      from_json       = ->(snap) { JSON.parse(snap).each.with_object({}, &symbolize_keys) }
      snapshot_hash   =
        if    :auto == format && snapshot.is_a?(Hash)
          from_hash.call(snapshot)
        elsif :auto == format && snapshot.is_a?(String)
          from_json.call(snapshot)
        elsif :hash == format
          from_hash.call(snapshot)
        elsif :json == format
          from_json.call(snapshot)
        elsif snapshot.respond_to?(:to_h)
          from_hash.call(snapshot)
        else
          from_json.call(snapshot.to_s)
        end
      self::Snapshot.new(snapshot_hash)
    end
  end

end
