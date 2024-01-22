require 'csv'
require 'rspec'
require 'byebug'

RSpec.describe "customer feedback data" do
  def csv_data
    @array ||= []
    if @array.length.zero?
      CSV.foreach(("customer_data.csv"), headers: true, col_sep: ",") do |row|
        @array << row
      end
    end
    @array
  end

  #Calculate the average feedback score.
  #Find the customer with the shortest response time and their corresponding feedback score.
  context "average score" do 
    def average_score
      time = {}
      time_array = []
      csv_data.each do |row| 
        # res_time = row["ResponseTime"].to_i
        # feedback_score = row["FeedbackScore"]
        # customer_id = row["CustomerID"]
          time["feedback_score"] = row["FeedbackScore"].to_i
           time["response_time"] = row["FeedbackScore"]
           time["customer_ID"] = row["CustomerID"]
           time.each do |key, value|
            time_array << value

        
      end
      time
    end
    it "" do
      expect(average_score).to eq(["C005" "FeedbackScore" "ResponseTime"])
    end
  end
end

# CustomerID,  FeedbackScore,  ResponseTime
#   C001,            4 ,             24
#   C002,            5,              48
#   C003,            3               72
#   C004,            2,              36
#   C005,            4,              12
#[#<CSV::Row "CustomerID":"C001" "FeedbackScore":"4" "ResponseTime":"24">, 
#<CSV::Row "CustomerID":"C0...":"2" "ResponseTime":"36">,
 #<CSV::Row "CustomerID":"C005" "FeedbackScore":"4" "ResponseTime":"12">]