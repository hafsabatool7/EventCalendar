# This class is the event class which stores all information related to an event

class Event
  attr_accessor :name, :description
  def initialize(ename, description)
    @name = ename
    @description = description
  end
end
