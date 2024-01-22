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
  context "Customer score" do 
    def average_score
      total_feedback_score = 0
      csv_data.each do |row|
        feedback_score = row["FeedbackScore"].to_i
        total_feedback_score += feedback_score
      end
      avg_feeback_score = total_feedback_score.to_f / csv_data.length
    end
      # time = {}
      # time_array = []
      # csv_data.each do |row| 
      #   # res_time = row["ResponseTime"].to_i
      #   # feedback_score = row["FeedbackScore"]
      #   # customer_id = row["CustomerID"]
      #     time["feedback_score"] = row["FeedbackScore"].to_i
      #     time["response_time"] = row["FeedbackScore"]
      #     time["customer_ID"] = row["CustomerID"]
      #     time.each do |key, value|
      #     time_array << value

    xit "average score" do
      expect(average_score).to eq(3.6)
    end
  end

  #Find the customer with the shortest response time and their corresponding feedback score.
  context "response time and feedback score" do
    def response_time
    #   csv_data.min_by do |element| 
    #     element["ResponseTime"].to_i
    #   end.to_h
    # end
      response_time = nil
      shortest_response_time = nil
      customer_id = nil
      feedback_score = nil
      csv_data.each do |row|
        response_time = row["ResponseTime"]
        if shortest_response_time.nil? || response_time < shortest_response_time
          shortest_response_time = response_time
          customer_id = row['CustomerID']
          feedback_score = row['FeedbackScore'].to_i
        end
      end
      [feedback_score, response_time] 
    end

    it "shortest resposnse time" do
      expect(response_time).to eq([4, "12"])   #{"CustomerID"=>"C005", "FeedbackScore"=>"4", "ResponseTime"=>"12"}
    end
  end
end
