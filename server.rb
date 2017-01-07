require 'socket'
require 'thread'
require 'opencv'
include OpenCV

$face_checker = false

Thread.new do
    tcp_server = TCPServer.new('192.168.0.100', 4567)
    srv = tcp_server.accept
    while true 
        srv.puts "#{$face_checker}"
    end
end

data = 'model.xml'
detector = CvHaarClassifierCascade::load(data)
capture = OpenCV::CvCapture.open
window = GUI::Window.new('Face detection')
while true do
  $face_checker = false
  image = capture.query
  detector.detect_objects(image).each do |region|
    $face_checker = true
    color = CvColor::Blue
    image.rectangle! region.top_left, region.bottom_right, :color => color
  end
  window.show(image)
  GUI::wait_key(1)
end