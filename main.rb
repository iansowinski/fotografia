require 'rubygems'
require 'rmagick'
require 'rubyserial'
require 'opencv'
include OpenCV

class Printer
    @@SerialPort = '/dev/ttyAMA0'
    @@BaudRate = 19200
    @@TimeOut = 3
    @@black_threshold = 48
    @@alpha_threshold = 127
    @@printer = nil
    @@ESC = 27.chr

    def initialize (heatTime=80, heatInterval=2, heatingDots=7, serialport=@@SerialPort)
          @printer = Serial.new(@@SerialPort, @@BaudRate)
          @printer.write(@@ESC)
          @printer.write(64.chr)
          @printer.write(@@ESC)
          @printer.write(55.chr)
          @printer.write(heatingDots.chr)
          @printer.write(heatTime.chr) 
          @printer.write(heatInterval.chr)
          printDensity = 15
          printBreakTime = 15 
          @printer.write(18.chr)
          @printer.write(35.chr)
          @printer.write(((printDensity << 4) | printBreakTime).chr)
    end
    def write (args)
      @printer.write(args)
    end
end

class ElemCellAutomat
  include Enumerable

  def initialize (start_str, rule, disp=false)
    @cur = start_str
    @patterns = Hash[8.times.map { |i| ["%03b"%i , "01"[rule[i]]] } ]
    puts "Rule (#{rule}) : #@patterns" if disp
  end

  def each
    return to_enum unless block_given?
    loop do
      yield @cur
      str = @cur[-1] + @cur + @cur[0]
      @cur = @cur.size.times.map {|i| @patterns[str[i,3]]}.join
    end
  end
end

eca = ElemCellAutomat.new('1'.center(10, '0'),75 , true) #30, 57, 45, 75

@master_array = []
eca.take(400).each_with_index do |eca_line, eca_index|
  face_checker = true
  while face_checker do
      data_face = 'file2.xml'
      detector = CvHaarClassifierCascade::load(data_face)
      capture = OpenCV::CvCapture.open
      capture.query.save('image.jpg')
      image = CvMat.load('image.jpg')
      n=0
      detector.detect_objects(image).each do |region|
          face_checker = false
      end
  end
  @master_array << []

  data = eca_line.split('')
  data.each do |item|
    if item == "0"
      @master_array[eca_index] << 0
    elsif item == "1"
      @master_array[eca_index] << 1
    end
  end
  print_bytes = []
  counter = 0
  chunkHeight = 1
  print_bytes = [18, 42, 1, 48]
  48.times do |i|
      byt = 0
      8.times do |n|
          pixel_value = @master_array[eca_index][counter]
          counter += 1
          if pixel_value == 0
              byt += 1<<(7-n)
          end
      end
      print_bytes << byt
  end
  print_bytes.each do |b|
      master_printer.write(b.chr)
  # end
  # print data.join()
  # puts ''
end

