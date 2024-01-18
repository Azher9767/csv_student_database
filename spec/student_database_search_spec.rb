require 'csv'
require 'byebug'
require 'rspec'

RSpec.describe "student database search" do
  def csv_data
    @array ||= []

    if @array.length.zero?
      CSV.foreach(("students_data.csv"), headers: true, col_sep: ",") do |row|
        @array << row
      end
    end
    @array
  end

  context "all_academic_periods" do
    def all_academic_periods
      csv_data.map do |row|
        row["entry_academic_period"]
      end.compact
    end

    it "list all academic period" do
      expect(all_academic_periods).to eq(["Fall 2008","Fall 2006", "Fall 2006", "Fall 2006", "Fall 2007", "Fall 2006", "Fall 2007", "Fall 2010", "Fall 2007"])
    end
  end

  context "all_students base on last name" do
    def search_by(args:)
      expected_keys = [:last_name, :email, :hs_city, :hs_state]
      return 'Unexpected args' unless expected_keys.include?(args.keys.first)

      csv_data.map do |row|
        row.to_s if row[args.keys.first.to_s] == args.values.first
      end.join(" ").strip
    end
    it "display student name " do 
      expect(search_by(args: {last_name: "Doe"})).to eq("111111,John,Doe,01/2000,Hispanic,M,FT,Fall 2008,,,,,,,,,,2.71,Albuquerque,New Mexico,87112,jdoe@example.com,17.9,FALSE,FALSE,TRUE")
    end
    
    it "display student name " do 
      expect(search_by(args: {last_name: "Joy"})).to eq("")
    end
    it "display student name " do 
      expect(search_by(args: {last_name: ""})).to eq("")
    end
  end

  context "list all student based on gpa " do
    def search_by_gpa(hs_gpa:, operator:)
      csv_data.map do |row|
        current_value = row["hs_gpa"].to_f
        passed_value = hs_gpa.to_f
        case operator 
          when ">" 
            row if current_value  > passed_value
          when "<" 
            row if current_value  < passed_value
          when "=" 
            row  if current_value = passed_value
          when "..." 
            row if current_value.between?(hs_gpa.split("...")[0].to_f, hs_gpa.split("...")[1].to_f)
            #The between? method in ruby is used to determine if a given valuein  between 
            #two other objects in a range,it returns true if the object is within the range, 
            #and false otherwise. Syntax is ==> object.between?(min, max)
          when ".." 
            row if current_value .between?(hs_gpa.split("..")[0].to_f, hs_gpa.split("..")[1].to_f)
        end
      end.join(" ").strip
    end

    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: 4, operator: ">")).to eq("id 111116 first_name Jennifer last_name Wilson date_of_birth 01/2002 ethnicity Asian gender M status TRANSFER entry_academic_period Fall 2006 exclusion_type  act_composite  act_math  act_english  act_reading  sat_combined  sat_math  sat_verbal  sat_reading  hs_gpa 4.24 hs_city Denver hs_state Colorado hs_zip 80012 email jwilson@example.com entry_age 18.5 ged TRUE english_2nd_language FALSE first_generation TRUE")
    end
    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: 4.0, operator: ">")).to eq("id 111116 first_name Jennifer last_name Wilson date_of_birth 01/2002 ethnicity Asian gender M status TRANSFER entry_academic_period Fall 2006 exclusion_type  act_composite  act_math  act_english  act_reading  sat_combined  sat_math  sat_verbal  sat_reading  hs_gpa 4.24 hs_city Denver hs_state Colorado hs_zip 80012 email jwilson@example.com entry_age 18.5 ged TRUE english_2nd_language FALSE first_generation TRUE")
    end

    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: "7", operator: ">")).to eq("")
    end
    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: "3", operator: "")).to eq("")
    end
    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: "3", operator: "<<")).to eq("")
    end
    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: "4..5", operator: "..")).to eq("id 111116 first_name Jennifer last_name Wilson date_of_birth 01/2002 ethnicity Asian gender M status TRANSFER entry_academic_period Fall 2006 exclusion_type  act_composite  act_math  act_english  act_reading  sat_combined  sat_math  sat_verbal  sat_reading  hs_gpa 4.24 hs_city Denver hs_state Colorado hs_zip 80012 email jwilson@example.com entry_age 18.5 ged TRUE english_2nd_language FALSE first_generation TRUE")
    end
    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: "4...5", operator: "...")).to eq("id 111116 first_name Jennifer last_name Wilson date_of_birth 01/2002 ethnicity Asian gender M status TRANSFER entry_academic_period Fall 2006 exclusion_type  act_composite  act_math  act_english  act_reading  sat_combined  sat_math  sat_verbal  sat_reading  hs_gpa 4.24 hs_city Denver hs_state Colorado hs_zip 80012 email jwilson@example.com entry_age 18.5 ged TRUE english_2nd_language FALSE first_generation TRUE")
    end
    it "search_by_gpa" do 
      expect(search_by_gpa(hs_gpa: "4..5", operator: "...")).to eq("")
    end
  end
end