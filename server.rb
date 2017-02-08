require 'socket'
require 'thread'
require 'opencv'
include OpenCV

$face_checker = false
server_ip = Socket.ip_address_list[3].ip_address
puts "server ip is #{server_ip}"

Thread.new do
    tcp_server = TCPServer.new(server_ip, 4567)
    srv = tcp_server.accept
    while true 
        srv.puts "#{$face_checker}"
    end
end

data = 'model.xml'
detector = CvHaarClassifierCascade::load(data)
color = CvColor::Yellow
video_size =  OpenCV::CvSize.new(200,150)
capture = OpenCV::CvCapture.open
capture.size=video_size
window = GUI::Window.new('Face detection')
while true do
  $face_checker = false
  image = capture.query
  detector.detect_objects(image).each do |region|
    $face_checker = true
    image.rectangle! region.top_left, region.bottom_right, :color => color, :thickness => 3
  end
  window.show(image)
  GUI::wait_key(1)
end
