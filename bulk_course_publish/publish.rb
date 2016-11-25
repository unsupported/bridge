require 'json'
require 'csv'
require 'typhoeus'
require 'colorize'

# Working as of 11/25/2016

# NOTE: This script assumes no external authentication is being used. If you are using
# non-Bridge authentication, this script will not work.

# You will need to create a one-column CSV file, with the headers set to 'course_id'
# You shouldn't need to set any values in this script. Once the script is run
# by executing 'ruby publish.rb', the script will then ask you for your inputs.

# Required inputs - Bridge URL, Bridge API key, Numerical User ID of an account admin, CSV path

def gather_data # The commands that retrieve required data from the User
  puts 'This script takes in a 1 column csv (set your column header to course_id)'
  puts 'Enter the Bridge instance URL (e.g. https://ibennion.bridgeapp.com)'
  @url = gets.chomp! # Prompts user for desired Bridge domain
  puts 'Enter your Bridge API Key'
  @token = gets.chomp!
  puts 'These calls require you masquerade as an admin. What is the admin user ID?'
  @admin_id = gets.chomp! # The 'publish' endpoint requires you masquerade as an admin. Set the admin's User ID here.
  puts 'Enter the path to your CSV mapping file (e.g. /Users/ibennion/Documents/mapping.csv)'
  @csv_path = gets.chomp! # Set your path to the csv file. e.g. '/Users/ccromar/Downloads/sample.csv'
end

def get_files file_path # Iterates through a one-column CSV file.
  CSV.foreach(file_path, headers: true) do |row|
    if row['course_id'].nil?
      puts 'No data in course_id'.red
      raise 'Valid CSV headers not found (no data in course_id)'
    else
      @course_id = row['course_id'].to_i
      'Course published'.green
    end
    token = @token
    begin
      acquire_lock
      publish_bridge_course
    rescue StandardError => e
      puts "Error: #{e}".red
    end
  end
  puts 'Courses complete.'.green
end

def acquire_lock # Retrieves the Lock ID needed to publish course. This is passed in the Publish request's headers
  request = Typhoeus.post(
  "#{@url}/api/author/course_templates/#{@course_id}/lock?as_user_id=#{@admin_id}",
  headers: { authorization: "Basic #{@token}", 'Content-Type': 'application/json', 'Accept': 'application/json' },
  )
  unless request.headers['status'] != "404 Not Found"
    raise "Invalid course id (#{@course_id}); ensure this course exists"
  end
  x = JSON.parse(request.body)
  @lock_id = x['lock']['id']
  puts "found lock id - #{@lock_id}, publishing course..."
end

def publish_bridge_course # API call to publish the course
  request = Typhoeus.post(
    "#{@url}/api/author/course_templates/#{@course_id}/publish?as_user_id=#{@admin_id}",
    headers: { authorization: "Basic #{@token}", 'X-Lock-Id': "#{@lock_id}" },
    body: {
        id: @course_id
    }
  )
  if request.code == 200
    puts "Course " + @course_id.to_s + " published".green
  else
    puts "Course " + @course_id.to_s + " failure".red
  end
  data = JSON.parse(request.body)
end

gather_data
get_files @csv_path
