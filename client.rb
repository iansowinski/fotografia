require 'socket'
require 'rubygems'
require 'rmagick'
require 'rubyserial'
require 'thread'

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

master_printer = Printer.new()

#host = ARGV[0]
#port = ARGV[1].to_i

host = '192.168.0.100'
port = 4567

@server = TCPSocket.open host, port
@face_checker = @server.gets

eca = ElemCellAutomat.new('1'.center(384, '0'),75 , true) #30, 57, 45, 75

Thread.new  do
    while true
        $face_checker = @server.gets.chomp
    end
end

eca.each_with_index do |eca_line, eca_index|
    if $face_checker == "false" 
        while $face_checker != "true" do
        end
    end

    data = eca_line.split('')
    data.each_with_index do |item, index|
      data[index] = item.to_i
    end
    print_bytes = []
    chunkHeight = 1
    print_bytes = [18, 42, 1, 48]
    48.times do |i|
        byt = 0
        8.times do |n|
            if data[i] == 0
                byt += 1<<(7-n)
            end
        end
        print_bytes << byt
    end
    print_bytes.each do |b|
      master_printer.write(b)
    end
end
