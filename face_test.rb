require 'opencv'
include OpenCV

    data = 'file2.xml'
    detector = CvHaarClassifierCascade::load(data)
    capture = OpenCV::CvCapture.open#CvMat.load(ARGV[0])
    sleep 1
    capture.query.save('image.jpg')
    sleep 1
    image = CvMat.load('image.jpg')
    detector.detect_objects(image).each do |region|
        color = CvColor::Lime
        image.rectangle! region.top_left, region.bottom_right, :color => color
    end
    image.save_image('detect.jpg')