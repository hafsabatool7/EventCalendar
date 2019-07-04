

require 'date'
require_relative 'event'
require 'colorize'

class EventCalendar
  attr_accessor :events_list
  @@MONTH_LENGTHS = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  SUCCESS = 'success'.freeze
  FAILURE = 'fail'.freeze

  def initialize
    @events_list = {}
  end

  def is_duplicate_event?(event_name, event_date)
    if @events_list.key?(event_date)
      events = @events_list[event_date]
      event = events.select { |event_obj| event_obj.name == event_name }
      if event.size.zero?
        return false
      end
    end
    true
  end

  def add_event!(event_name, event_desc, event_date)
    # Creating an Event
    event = Event.new(event_name, event_desc)
    # Adding Event to Event List
    # if that date doesn't exist as key already
    if @events_list.key?(event_date)
      if is_duplicate_event?(event_name, event_date)
        puts 'Duplicate Events Not Allowed: An event with the same name already exists on this date!'.red
        puts 'Returning to menu...'
        return FAILURE
      end
      @events_list[event_date].push(event)
    else
      @events_list[event_date] = []
      @events_list[event_date].push(event)
    end
    puts "Event successfully added! \n \n".green
    SUCCESS
  end

  def remove_event!(event_name, event_date)
    if @events_list.key?(event_date)
      events = @events_list[event_date]
      size = events.size
      events.delete_if { |event| event.name == event_name }
      if events.size == size
        puts "No such event exists! \n".red
        return FAILURE
      end
      # also if that array has now become emptied, delete that key on hash
      if events.empty?
        @events_list.delete(event_date)
      end
      puts "Successfully deleted the event! \n \n".green
      return SUCCESS
    else
      puts "No such event exists! \n".red
      return FAILURE
    end
  end

  def edit_event!(event_name, event_date)
    if is_duplicate_event?
      puts "Event Name: #{event[0].name} \nEvent Details: #{event[0].description} \n"
      puts "(NOTE: Leave blank any information that you do not want to update!) \n"
      print 'Enter New Name: '
      event_name = gets
      puts
      print 'Enter New Description: '
      event_desc = gets
      puts
      event[0].name = event_name unless event_name.chomp.empty?
      event[0].description = event_desc unless event_desc.chomp.empty?
      puts "Event information updated! \n \n".green
      return 'Event information updated!'
    else
      puts "No such event exists! \n".red
    end
    FAILURE
  end

  def edit_event_alt!(event_name, event_date, new_name, new_desc)
    if @events_list.key?(event_date)
      # print event info before asking for edit
      events = @events_list[event_date]
      event = events.select { |event_obj| event_obj.name == event_name }
      if event.size .zero?
        puts "No such event exists! \n"
        return FAILURE
      end
      event[0].name = new_name unless new_name.chomp.empty?
      event[0].description = new_desc unless new_desc.chomp.empty?
      puts "Event information updated! \n \n".green
      return SUCCESS
    else
      puts "No such event exists! \n".red
      return FAILURE
    end
  end

  def print_event_on_date(event_date)
    if @events_list.key?(event_date)
      events = @events_list[event_date]
      events.each { |event| puts "Event Name: #{event.name}Event Details: #{event.description} \n ---------------------------------------------" }
      return SUCCESS
    else
      puts "No event entry exists for this date! \n".red
    end
  end

  def print_events_for_month(month)
    if month.between?(1, 12)
      # get all the keys from hash that have month as given
      events = @events_list.select { |key, _| key.month == month }
      # if no entry for given month
      if events.empty?
        puts 'No event entry for the given month!'
        return FAILURE
      end
      events.each do |key, value|
        puts "Event Date: #{key}"
        value.each { |event| puts "\nEvent Name: #{event.name}Event Details: #{event.description} \n ---------------------------------------------" }
      end
      return SUCCESS
    else
      puts 'Invalid Input! Retry with valid input in range 1-12!'.red
    end
  end

  def month_length(month = Date.today.month, year = Date.today.year)
    if month.between?(1, 12) && year > 0
      return 29 if month == 2 && Date.gregorian_leap?(year)
      @@MONTH_LENGTHS[month]
    end
  end

  def print_calendar(month = Date.today.month, year = Date.today.year)
    if month.between?(1, 12) && year > 0
      day = Date.new(year, month, 1).cwday
      days_count = month_length(month, year)
      arr = *('1'..days_count.to_s)
      (day - 1).times { arr.unshift("\t") }
      puts "Mon\tTues\tWed\tThurs\tFri\tSat\tSun".blue
      arr.each_slice(7) do |events|
        events.each do |x|
          print x
          unless x == "\t"
            date = Date.new(year, month, x.to_i)
            if events_list.key? date
              number = events_list[date].size
              print "(#{number})"
            end
            print "\t"
          end
        end
        puts
      end
    else
      puts 'Invalid Input for Month!'
      FAILURE
    end
  end
end
