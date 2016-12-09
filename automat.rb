# Skrypt generuje automat komórkowy i drukuje go linia po linii (z użyciem py-thermal-library) na drukarce termicznej

require 'rubygems'
require 'rmagick'
#system('sudo stty -F /dev/ttyAMA0 19200')
#printer_temp = IO.sysopen('/dev/ttyAMA0', 'w+')
#$printer = IO.new(printer_temp)
#$printer.write("\e@")
#$printer.write("\e35")

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

eca = ElemCellAutomat.new('1'.center(384, '0'),30 , true) #30, 57, 45, 75
#while true
@master_array = []
eca.take(1000).each_with_index do |eca_line, eca_index|
  @master_array << []

  data = eca_line.split('')
  
  data.each do |item|
    if item == "0"
      @master_array[eca_index] << [0,0,0]
    elsif item == "1"
      @master_array[eca_index] << [255,255,255]
    end
  end
end

width = @master_array[0].length
height = @master_array.length

img = Magick::Image.new(width, height)
n = 0
@master_array.each_with_index do |row, row_index|
  row.each_with_index do |item, column_index|
    #puts "setting #{row_index}/#{column_index} to #{item}"
    img.pixel_color(column_index, row_index, "rgb(#{item.join(', ')})")
  end
end
img.write('demo.bmp')
system('python obrazek2.py')

