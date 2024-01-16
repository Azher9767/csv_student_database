require 'csv'
require 'byebug'

def csv_data
  @array ||= []

  if @array.length.zero?
    CSV.foreach(("students_data.csv"), headers: true, col_sep: ",") do |row|
      @array << row
  end
end
  @array
end

def all_academic_periods
  csv_data
end
#puts all_academic_periods.compact
 all_academic_periods.compact
# ==================================================================================

def count_male_and_female
  array = []
  array2 = []

  csv_data.each do |row|
    if row[5] == "M"
      array <<  row[5].length
    end
    if row[5] == "F"
      array2 << row[5].length
    end
  end

  "Total male are #{array.length} and total female are #{array2.length}"
end
#puts count_male_and_female
count_male_and_female
#=================================================================================
# options can have keys like last_name, email, city, state
# operator can have values like '>', '<', '='
# options: {last_name: 'azher', operator: '>'}
def search_by(args:)
  result = []
  expected_keys = [:last_name, :email, :hs_city, :hs_state]
  #expected_operators = ['>']
  return 'Unexpected args' unless expected_keys.include?(args.keys.first) # || expected_operators.include?(expected_operators.first)
  csv_data.each do |row|
    if row[args.keys.first.to_s] == args.values.first 
      result << row.to_s
    end
  end
  result.join(" ")
end
  # p search_by(args: {last_name: "Doe"})
  # p search_by(args: {hs_city: "Denver"})
  # p search_by(args: {email: "jdoe@example.com"})
  # p search_by(args: {hs_state: "New York"})
  # p search_by(args: {hs_gpa: ">"})

# expect(search_by(last_name: 'azher', operator: '=')).to eq('Azher')
# array3 = []
# CSV.foreach(("students_data.csv"), headers: true, col_sep: ",") do |row|
#     res = row.select{|col, r| print col} 
# end
#p array3.compact

def search_by_gpa(hs_gpa:, operator:)
  output = []
  csv_data.each do |row|
    case operator 
      when ">"
        if row["hs_gpa"].to_f > hs_gpa.to_f
          output << row
        end
      when "<"
        if row["hs_gpa"].to_f < hs_gpa.to_f
          output << row
        end
      when "="
        if row["hs_gpa"].to_f == hs_gpa.to_f
          output << row
        end
        byebug
       when ".."
        if row["hs_gpa"].to_f.between?(hs_gpa.split("..")[0].to_f, hs_gpa.split("..")[1].to_f)
          output << row
          #The between? method in ruby is used to determine if a given valuein  between 
          #two other objects in a range,it returns true if the object is within the range, 
          #and false otherwise. Syntax is ==> object.between?(min, max)
        end
      end
    end
  output
end
  p search_by_gpa(hs_gpa: "4..5", operator: "..")

  
  
