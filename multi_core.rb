# require 'thread'
# require 'opencv'
# include OpenCV

# @face_checker = true
# data = 'file2.xml'
# detector = CvHaarClassifierCascade::load(data)
# capture = OpenCV::CvCapture.open
# n=0
# def func1
#    print $face_checker
#    @face_checker = true
#    while true do
#          capture.query.save("image#{n}.jpg")
#          image = CvMat.load("image#{n}.jpg")
#          detector.detect_objects(image).each do |region|
#               @face_checker = false
#               color = CvColor::Blue
#               image.rectangle! region.top_left, region.bottom_right, :color => color
#          end
#    end
# end

# def func2
#    $i = 0
#    while true do
#       while @face_checker == true do
#       end
#       $i = i + 1
#       puts($i)
#    end
# end

require 'thread'
job_lock = Mutex.new
kid_lock = Mutex.new

$o = Mutex.new
def o(msg)
  $o.synchronize{
    t = Time.now; puts "%02d:%06.3f %s" % [ t.min, t.to_f%60, msg]
  }
end

# Simulate jobs coming into a queue
current_chores = []
CHORES = [
  "mow the cat", "wash the lawn", "order pizza",
  "answer questions on s/o", "cover cat in soothing lotion",
  "rinse suds off lawn", "pay more attention"
]
Thread.new do
  loop do
    sleep rand*5+3
    job_lock.synchronize do
      while true
        current_chores << (j=CHORES.shift)
        o "New job in the queue: '#{j}'"
      end
    end
  end
end

# A simple queue of machines to use
free_kids = %w[ Jimmy Susan ]

# The meat
loop do
  until job = job_lock.synchronize{ current_chores.shift }
    o "Waiting for a job..."
    sleep 1 # Look for new jobs every second
  end
  until kid = kid_lock.synchronize{ free_kids.shift }
    o "Waiting for a free child to do my bidding..."
    sleep 2 # Look for new kids every 2 seconds
  end
  Thread.new do
    o "#{kid} is now performing '#{job}'"
    sleep rand*10+10 # Simulate long process
    o "#{kid} FINISHED '#{job}'"
    kid_lock.synchronize{ free_kids << kid }
  end
end