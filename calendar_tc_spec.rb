# This file contains test cases for calendar

require_relative 'event_calendar'
require 'date'

describe EventCalendar do
  SUCCESS = 'success'.freeze
  FAILURE = 'fail'.freeze
  context 'Testing for valid inputs: ' do
    before(:each) do
      # initialize and run start
      @ec = EventCalendar.new
    end
    # NOTE: contains no tests for date because the function handling
    # invalid dates also requires terminal input!
    it 'should add an event for valid inputs' do
      expect(@ec.add_event!('Name1', 'Description1', Date.strptime('2015-5-9', '%Y-%m-%d'))).to eql SUCCESS
    end

    it 'should edit event information for valid inputs' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19'))
      expect(@ec.edit_event_alt!('Name1', Date.strptime('2015-11-19', '%Y-%m-%d'), 'New Name', '')).to eql SUCCESS
    end

    it 'should remove the event for valid inputs' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19', '%Y-%m-%d'))
      expect(@ec.remove_event!('Name1', Date.strptime('2015-11-19', '%Y-%m-%d'))).to eql SUCCESS
    end

    it 'should print event information for a valid given date ' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19', '%Y-%m-%d'))
      expect(@ec.print_event_on_date(Date.strptime('2015-11-19', '%Y-%m-%d'))).to eql SUCCESS
    end

    it 'should print event information for a valid given month' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19', '%Y-%m-%d'))
      expect(@ec.print_events_for_month(11)).to eql SUCCESS
    end

    it 'should print the calendar for valid month and year' do
      expect(@ec.print_calendar(11, 2019)).not_to eql FAILURE
    end

    it 'should return correct month length for given valid month and year' do
      expect(@ec.month_length(2, 2012)).to eql 29
    end
  end

  context 'Testing for invalid inputs:' do
    before(:each) do
      # initialize and run start
      @ec = EventCalendar.new
    end

    # It needs not to be tested for add_event! because the only
    # thing that could cause
    # failure is when there is invalid date -- and that is
    # already handled in take_all_inputs method from driver

    # take_all_inputs is not tested because it is accepting inputs
    # from command line

    it 'should not remove the event when invalid input' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19'))
      expect(@ec.remove_event!('XXXX', Date.strptime('2015-11-19', '%Y-%m-%d'))).not_to eql SUCCESS
    end

    it 'should not edit the event when invalid input' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19'))
      expect(@ec.edit_event_alt!('XXXX', Date.strptime('2015-11-19', '%Y-%m-%d'), 'New Name', '')).not_to eql SUCCESS
    end

    it 'should not print event information for invalid input' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19'))
      expect(@ec.print_event_on_date(Date.strptime('2015-11-9', '%Y-%m-%d'))).not_to eql SUCCESS
    end

    it 'should not print event information for invalid' do
      @ec.add_event!('Name1', 'Description1', Date.strptime('2015-11-19', '%Y-%m-%d'))
      expect(@ec.print_events_for_month(7)).not_to eql SUCCESS
    end

    it 'should not print the calendar for the invalid month' do
      expect(@ec.print_calendar(121, 2019)).to eql FAILURE
    end

    it 'should not print the calendar for the invalid year' do
      expect(@ec.print_calendar(11, -2019)).to eql FAILURE
    end

    it 'should return error for incorrect month or year' do
      expect(@ec.month_length(22, 2012)).to be_falsey
    end
  end
end
