# This file contains test cases for calendar

require_relative 'event_calendar'
require 'date'

describe EventCalendar do
  context 'Testing for valid inputs: ' do
    before(:each) do
      # initialize and run start
      @ec = EventCalendar.new
    end
    # NOTE: contains no tests for date because the function handling
    # invalid dates also requires terminal input!
    it 'should add an event when user selects the option for it and enters information' do
      expect(@ec.add_event('Name1', 'Description1', Date.parse('2015-5-9'))).to eql 'success'
    end

    it 'should edit event information when user selects the option for it and enters information' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.edit_event_alt('Name1', Date.parse('2015-11-19'), 'New Name', '')).to eql 'success'
    end

    it 'should remove the event when user selects the option for it and enters information' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.remove_event('Name1', Date.parse('2015-11-19'))).to eql 'success'
    end

    it 'should print event information for a given date when user selects the option for it and enters the date' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.print_event_on_date(Date.parse('2015-11-19'))).to eql 'success'
    end

    it 'should print event information for a given month when user selects the option for it and enters month number' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.print_events_for_month(11)).to eql 'success'
    end

    it 'should print the calendar for the month and year given as input by the user' do
      expect(@ec.print_calendar(11, 2019)).not_to eql 'fail'
    end

    it 'should return correct month length for given month and year' do
      expect(@ec.month_length(2, 2012)).to eql 29
    end
  end

  context 'Testing for invalid inputs:' do
    before(:each) do
      # initialize and run start
      @ec = EventCalendar.new
    end

    # It needs not to be tested for add_event because the only
    # thing that could cause
    # failure is when there is invalid date -- and that is
    # already handled in take_all_inputs method

    # take_all_inputs is not tested because it is accepting inputs
    # from command line

    it 'should not remove the event when user enters incorrect information' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.remove_event('XXXX', Date.parse('2015-11-19'))).not_to eql 'success'
    end

    it 'should not edit the event when user enters incorrect information' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.edit_event('XXXX', Date.parse('2015-11-19'))).not_to eql 'success'
    end

    it 'should not print event information for a given date when user enters incorrect date' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.print_event_on_date(Date.parse('2015-11-9'))).not_to eql 'success'
    end

    it 'should not print event information for a given month when user selects the option for it and enters month number' do
      @ec.add_event('Name1', 'Description1', Date.parse('2015-11-19'))
      expect(@ec.print_events_for_month(7)).not_to eql 'success'
    end

    it 'should not print the calendar for the invalid month given as input by the user' do
      expect(@ec.print_calendar(121, 2019)).to eql 'fail'
    end

    it 'should not print the calendar for the invalid year given as input by the user' do
      expect(@ec.print_calendar(11, -2019)).to eql 'fail'
    end

    it 'should return error for incorrect month or year' do
      expect(@ec.month_length(22, 2012)).to be_falsey
    end
  end
end
