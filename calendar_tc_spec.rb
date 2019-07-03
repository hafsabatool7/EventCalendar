#This file contains test cases for calendar

require_relative 'EventCalendar'
require 'date'


describe EventCalendar do
    context "Testing for valid inputs: " do

    before(:each) do 
        #initialize and run start
        @ec = EventCalendar.new
     end 

    it "should add an event when user selects the option for it and enters information" do
      expect(@ec.addEvent('Name1','Description1', Date.parse('2015-5-9'))).to eql "success"
    end

    it "should edit event information when user selects the option for it and enters information" do
       @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
       expect(@ec.editEventAlt('Name1',Date.parse('2015-11-19'), 'New Name', '')).to eql "success"
    end

    it "should remove the event when user selects the option for it and enters information" do
      @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
      expect(@ec.removeEvent('Name1',Date.parse('2015-11-19'))).to eql "success"
    end

    it "should print event information for a given date when user selects the option for it and enters the date" do
       @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
       expect(@ec.printEventOnDate(Date.parse('2015-11-19'))).to eql "success"
    end

    it "should print event information for a given month when user selects the option for it and enters month number" do
        @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
        expect(@ec.printEventsForAMonth(11)).to eql "success"
    end

    it "should print the calendar for the month and year given as input by the user" do
      expect(@ec.printCalendar(11,2019)).not_to eql "fail"
    end

    it "should return correct month length for given month and year" do
      expect(@ec.month_length(2,2012)).to eql 29
    end

  end

  context "Testing for invalid inputs: " do
    before(:each) do 
        #initialize and run start
        @ec = EventCalendar.new
    end


    #It needs not to be tested for AddEvent because the only thing that could cause
    #failure is when there is invalid date -- and that is already handled in takeAllInputs method

    #takeAllInputs is not tested because it is accepting inputs from command line

    it "should not remove the event when user enters incorrect information" do
      @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
      expect(@ec.removeEvent('XXXX',Date.parse('2015-11-19'))).not_to eql "success"
    end

    it "should not edit the event when user enters incorrect information" do
      @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
      expect(@ec.editEvent('XXXX',Date.parse('2015-11-19'))).not_to eql "success"
    end

    it "should not print event information for a given date when user enters incorrect date" do
       @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
       expect(@ec.printEventOnDate(Date.parse('2015-11-9'))).not_to eql "success"
    end

    it "should not print event information for a given month when user selects the option for it and enters month number" do
        @ec.addEvent('Name1','Description1', Date.parse('2015-11-19'))
        expect(@ec.printEventsForAMonth(7)).not_to eql "success"
    end

    it "should not print the calendar for the invalid month given as input by the user" do
        expect(@ec.printCalendar(121,2019)).to eql "fail"
    end

    it "should not print the calendar for the invalid year given as input by the user" do
        expect(@ec.printCalendar(11,-2019)).to eql "fail"
    end

    it "should return error for incorrect month or year" do
      expect(@ec.month_length(22,2012)).to be_falsey
    end

  end

end
