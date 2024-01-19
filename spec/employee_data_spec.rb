require 'csv'
require 'rspec'
require 'byebug'

RSpec.describe "employee data" do
  def csv_data
    @array ||= []
    if @array.length.zero?
      CSV.foreach(("employee_data.csv"), headers: true, col_sep: ",") do |row|
        @array << row
      end
    end
    @array
  end

# Identify employees who joined before 2020 and have a salary above $75,000
  context "employee information" do
    def employee_info
      data = []
        csv_data.each do |row|
          if row["JoinDate"] < '2020-01-01' && row["Salary"].to_i > 75000
            data << {name: row["Name"],
            join_date: row["JoinDate"],
            salary: row["Salary"]}
          end
        end
      data
    end 

    it "Identify employee's joined date & salary" do 
      expect(employee_info).to eq([])
    end
  end

  #================================================================================
  # Determine the average salary of each department.
  context "Average salary" do
    def avergae_salary
       salary_department = {}
        csv_data.each do |row|
          department = row['Department']
          salary = row['Salary'].to_i
          if salary_department[department]
            salary_department[department] << salary
          elsif
            salary_department[department] = [salary]
          end
        end
      avg_sal = {}
      salary_department.each do |department, sal|
        avg = sal.sum / sal.size
        avg_sal[department] = avg
      end
      avg_sal
    end
  
    it "average salary of each department" do 
      expect(avergae_salary).to eq({"Finance"=>78000, "IT"=>78500, "Marketing"=>70000, "Sales"=>65000})
    end
  end
end 
