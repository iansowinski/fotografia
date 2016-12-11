require "opencv"

puts Time.now
10.times do |time|
    capture = OpenCV::CvCapture.open
     # Warming up the webcam
    capture.query.save("image#{time}.jpg")
    if time == 10
        capture.close
    end
end
puts "Done!"
puts Time.now