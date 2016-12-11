require 'opencv'
include OpenCV

# if ARGV.length < 2
#   puts "Usage: ruby #{__FILE__} source dest"
#   exit
# end
#system('open ~/../../../usr/local/Cellar/opencv/HEAD-7be4a0e/share/OpenCV/haarcascades/haarcascade_frontalface_alt.xml')

#data = '/usr/local/Cellar/opencv/HEAD-7be4a0e/share/OpenCV/haarcascades/haarcascade_frontalface_alt2.xml'
face_checker = true
lol = nil
data = 'file2.xml'
detector = CvHaarClassifierCascade::load(data)
capture = OpenCV::CvCapture.open
n=0
while face_checker do
n += 1
capture.query.save("image#{n}.jpg")
#catch :done do
    #sleep 1
    image = CvMat.load("image#{n}.jpg")
    detector.detect_objects(image).each do |region|
        puts n
        color = CvColor::Blue
        image.rectangle! region.top_left, region.bottom_right, :color => color
    end
    
    #image.save_image('detect.jpg')
    # if lol == nil
    #     window = GUI::Window.new('Face detection')
    #     window.show(image)
    #     lol = 1
    # else
    #     window.show(image)
    # end
end