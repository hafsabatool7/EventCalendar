require 'date'
require 'colorize'
require_relative 'event_calendar'

class Driver
  attr_accessor :event_calendar

  def initialize
    @event_calendar = EventCalendar.new
  end

  def start
    puts '*********** Welcome to Event Calendar **************'
    # print today's date and calendar for this month
    today = Date.today
    puts
    puts "Today is #{today}"
    puts "__________________________________________________ \n \n"
    puts "Calendar for #{Date::MONTHNAMES[today.month]} >> \n"
    @event_calendar.print_calendar
    input = ''
    until input == 'exit' do
      input = print_options
    end
  end

  def print_menu
    puts "\n \n __________________________________________________ \n \n".cyan
    puts '<><><><><><><><> MENU <><><><><><><><> '.cyan
    puts '> To ADD an Event, press [1]'.cyan
    puts '> To REMOVE an Event, press [2]'.cyan
    puts '> To EDIT an Event, press [3]'.cyan
    puts '> To Print Calendar for a Month, press [4]'.cyan
    puts '> To Print Events on a Date, press [5]'.cyan
    puts '> To Print Event Details for a Month, press [6]'.cyan
    puts '> To Quit or Exit the program, press any other key! '.cyan
    print "\n \n Your Input:"
  end

  def print_options
    print_menu
    input = gets
    puts
    input = input.chomp
    case input
    when '1'
      puts '<*> Adding an Event: '.yellow
      event_name, event_desc, event_date = take_all_inputs(true, true, true)
      @event_calendar.add_event!(event_name, event_desc, event_date)
    when '2'
      puts '<*> Removing an Event: '.yellow
      event_name, _, event_date = take_all_inputs(true, false, true)
      @event_calendar.remove_event!(event_name, event_date)
    when '3'
      puts '<*> Editing an Event: '.yellow
      event_name, _, event_date = take_all_inputs(true, false, true)
      puts "Enter NEW information: \n (NOTE: Leave blank any information that you do not want to update!) \n \n"
      print 'Enter New Name: '
      event_name_new = gets
      puts
      print 'Enter New Description: '
      event_desc_new = gets
      puts
      @event_calendar.edit_event_alt!(event_name, event_date, event_name_new, event_desc_new)
    when '4'
      puts '<*> Printing Calendar for a month: '.yellow
      print 'Enter Month Number (1-12): '
      month = gets
      month = month.to_i
      print 'Enter Year: '
      year = gets
      year = year.to_i
      @event_calendar.print_calendar(month, year)
    when '5'
      puts '<*> Printing Event on any date: '.yellow
      _, _, event_date = take_all_inputs(false, false, true)
      @event_calendar.print_event_on_date(event_date)
    when '6'
      puts '<*> Printing Event in any month: '.yellow
      print 'Enter Month Number (1-12): '
      month = gets
      month = month.to_i
      @event_calendar.print_events_for_month(month)
    else
      puts 'Exiting the program...'.yellow
      return 'exit'
    end
  end

  # takes input from command line
  def take_all_inputs(names, desc, date)
    event_name, event_desc, event_date = nil
    if names
      puts 'Please enter the information for the event as required below: '
      print 'Event Name: '
      event_name = gets
    end
    if desc
      print 'Event Description: '
      event_desc = gets
    end
    if date
      begin
        print 'Event Date (yyyy-mm-dd): '
        event_date = gets
        event_date = Date.strptime(event_date, '%Y-%m-%d')
      rescue ArgumentError
        puts 'Invalid Date! Retry...'.red
        retry
        # return nil, nil, nil
      end
      puts
    end
    return event_name, event_desc, event_date
  end
end

driver = Driver.new
driver.start
