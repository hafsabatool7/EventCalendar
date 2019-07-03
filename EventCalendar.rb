require 'date'
require_relative 'Event'

class EventCalendar

    attr_accessor :events_list
    MONTHLENGTHS = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    def initialize
        @events_list = Hash.new
    end

    def start

        puts "*********** Welcome to Event Calendar **************"

        #print today's date and calendar for this month

        today = Date.today
        puts ""
        puts "Today is #{today}"

        puts "__________________________________________________ \n \n"

        puts "Calendar for #{Date::MONTHNAMES[today.month]} >> \n"

        printCalendar

        input = ""
        until input == 'exit' do
          input = print_options input
        end
    end

    def print_options(input)
        puts "\n \n __________________________________________________ \n \n"
        puts '<><><><><> MENU <><><><><> '
        puts '> To ADD an Event, press 1'
        puts '> To REMOVE an Event, press 2'
        puts '> To EDIT an Event, press 3'
        puts '> To Print Calendar for a Month, press 4'
        puts '> To Print Events on a Date, press 5'
        puts '> To Print Event Details for a Month, press 6'
        puts '> To Quit or Exit the program, press any other key'

        print "\n \n Your Input:"
        input = gets

        puts ""
        input = input.chomp
        case input
        when '1'
          puts "<*> Adding an Event: "
          event_name, event_desc, event_date = takeAllInputs(true, true,true)
          unless event_date.nil?
            addEvent(event_name, event_desc, event_date)
          end

        when '2'
          puts "<*> Removing an Event: "
          event_name, event_desc, event_date = takeAllInputs(true,false,true)
          unless event_date.nil?
            removeEvent(event_name,event_date)
          end

        when '3'
          puts "<*> Editing an Event: "
          event_name, event_desc, event_date = takeAllInputs(true,false,true)
         puts "Enter NEW information:"
          puts "(NOTE: Leave blank any information that you do not want to update!) \n"
          print "Enter New Name: "
          event_name_new = gets
          puts ""
          print "Enter New Description: "
          event_desc_new = gets
          puts ""
          unless event_date.nil?
            editEventAlt(event_name,event_date,event_name_new,event_desc_new)
          end
          
        when '4'
          puts "<*> Printing Calendar for a month: "
          print 'Enter Month Number (1-12): '
          month = gets
          month = month.to_i
          print 'Enter Year: '
          year = gets
          year = year.to_i

          printCalendar(month, year)

        when '5'
          puts "<*> Printing Event on any date: "
          event_name, event_desc, event_date = takeAllInputs(false,false,true)
          unless event_date.nil?
            printEventOnDate(event_date)
          end

        when '6'
          puts "<*> Printing Event in any month: "
          print 'Enter Month Number (1-12): '
          month = gets
          month = month.to_i
          printEventsForAMonth(month)

        else
          puts "Exiting the program..."
          return 'exit'

        end

    end

    def takeAllInputs(names, desc, date)

      event_name, event_desc, event_date = nil,nil,nil
      if names
        puts "Please enter the information for the event as required below: "
        print 'Event Name: '
        event_name = gets
        puts ""

      end

      if desc

        print 'Event Description: '
        event_desc = gets
        puts ""

      end

      if date
        print 'Event Date (yyyy-mm-dd): '
        event_date = gets

        begin
           event_date = Date.parse(event_date)
        rescue ArgumentError
          p "Invalid Date! Retry..."
          return nil,nil,nil
        end

        puts ""

      end

        return event_name, event_desc, event_date

    end

    def addEvent(event_name, event_desc, event_date)

      #Creating an Event
      e = Event.new(event_name, event_desc)

      #Adding Event to Event List
      #if that date doesn't exist as key already

      if @events_list.key?(event_date)
         @events_list[event_date].push(e)
      else
         @events_list[event_date] = Array.new
         @events_list[event_date].push(e)

      end

      puts "Event successfully added! \n \n"
      return "success"

    end

    def removeEvent(event_name, event_date)

       if @events_list.key?(event_date)

          events = @events_list[event_date]
          size = events.size
          events.delete_if { |e| e.name == event_name}
          if events.size == size
            puts "No such event exists! \n"
            return
          end

          #also if that array has now become emptied, delete that key on hash

          if events.empty?
            @events_list.delete(event_date)
          end

         puts "Successfully deleted the event! \n \n"
         return "success"
       else
         puts "No such event exists! \n"
         return "fail"
       end

    end

    def editEvent(event_name, event_date)

       if @events_list.key?(event_date)
            #print event info before asking for edit
            events = @events_list[event_date]
            event = events.select { |e| e.name == event_name}
            
            if event.size == 0
              puts "No such event exists! \n"
              return
            end

            puts "Event Name: #{event[0].name} \nEvent Details: #{event[0].description} \n"
            puts "(NOTE: Leave blank any information that you do not want to update!) \n"
            print "Enter New Name: "
            event_name = gets
            puts ""
            print "Enter New Description: "
            event_desc = gets
            puts ""

            unless event_name.chomp.empty?
                event[0].name = event_name
            end
            unless event_desc.chomp.empty?
                event[0].description = event_desc
            end

            puts "Event information updated! \n \n"
            return "Event information updated!"

       else
        puts "No such event exists! \n"

       end

    end

     def editEventAlt(event_name, event_date, new_name, new_desc)

       if @events_list.key?(event_date)
            #print event info before asking for edit
            events = @events_list[event_date]
            event = events.select { |e| e.name == event_name}
            
            if event.size == 0
              puts "No such event exists! \n"
              return "fail"
            end

            unless new_name.chomp.empty?
                event[0].name = new_name
            end
            unless new_desc.chomp.empty?
                event[0].description = new_desc
            end

            puts "Event information updated! \n \n"
            return "success"

       else
          puts "No such event exists! \n"
          return "fail"
       end

    end


    def printEventOnDate(event_date)
  
      if @events_list.key?(event_date)

        events = @events_list[event_date]
        events.each { |e| puts "Event Name: #{e.name} \nEvent Details: #{e.description} \n ---------------------------------------------"}
        return "success"
      else
        puts "No event entry exists for this date! \n"
      end

    end

    def printEventsForAMonth(month)

      if month.between?(1,12)

        #get all the keys from hash that have month as given
        events = @events_list.select {|e,v| e.month == month}

        #if no entry for given month
        if events.empty?
          puts "No event entry for the given month!"
          return
        end

        events.each do |e, v| 
          puts "Event Date: #{e}"
          v.each {|d| puts "\nEvent Name: #{d.name} \nEvent Details: #{d.description} \n ---------------------------------------------"}
        
        end
          return "success"

      else
        puts "Invalid Input! Retry with valid input in range 1-12!"
      end

    end

    def month_length(month = Date.today.month, year = Date.today.year)

       return 29 if month == 2 && Date.gregorian_leap?(year)
       MONTHLENGTHS[month]

    end

    def printCalendar(month = Date.today.month, year = Date.today.year)
      if month.between?(1,12) and year > 0
        #getting 1st day of month
        day = Date.new(year, month, 1).cwday

        #make an arr
        days_count = month_length(month,year)
        arr = *('1'..days_count.to_s)

        #insert as many tabs as required
        (day-1).times {arr.unshift("\t")}
        #print header
        puts "Mon\tTues\tWed\tThurs\tFri\tSat\tSun"

        #slice and print

        arr.each_slice(7) do |v|

          for x in v
            print "#{x}"

            #check for events on this date and print tab

            unless x == "\t"
              date = Date.new(year,month,x.to_i)

              if events_list.has_key? date
                number = events_list[date].size
                print "(#{number})"
              end

              print "\t"
            end
          end
          puts ""
        end

      else
        puts "Invalid Input for Month!"
        return "fail"
      end

    end

end

ec = EventCalendar.new
ec.start