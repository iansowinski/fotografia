# Próba napisania sterownika do drukarki termicznej adafruit

system('sudo stty -F /dev/ttyAMA0 19200')
printer_temp = IO.sysopen('/dev/ttyAMA0', 'w+')
$printer = IO.new(printer_temp)

#te dwie linijki czyszczą bufor i przywracają wszystko do domyślnych ustawień
$printer.write("\e@")

#funkcja pozbywa się polskich znaków
def go_english(argument)
  array_polish = ["ą", "ć", "ę", "ł", "ń", "ó", "ś", "ź", "ż", "Ą", "Ć", "Ę", "Ł", "Ń", "Ó", "Ś", "Ź", "Ż"]
  array_latin = ["a", "c", "e", "l", "n", "o", "s", "z", "z", "A", "C", "E", "L", "N", "O", "S", "Z", "Z"]
  array_polish.each_with_index do |pl, id|
    argument = argument.gsub(pl, array_latin[id])
  end
  return argument 
end


def bold (argument)
  $printer.write("\eE1")
  $printer.puts(argument)
  $printer.write("\eE2")
end

def align (argument, position)
  case position
  when "left"
    $printer.write("\ea0")
    $printer.puts(argument)
    $printer.write("\ea0")
  when "right"
    $printer.write("\ea2")
    $printer.puts(argument)
    $printer.write("\ea0")
  when "center"
    $printer.write("\ea1")
    $printer.puts(argument)
    $printer.write("\ea0")
  end
end

def invert (argument)
  $printer.write("#{29.chr}B1")
  $printer.print(argument)
  $printer.write("#{29.chr}B0")
end

def underline (argument)
  $printer.write("\e-1")
  $printer.puts(argument)
  $printer.write("\e-0")
end

def mode (argument, mode_num)
  $printer.write("\e!#{mode_num}#{FALSE}")
  $printer.puts(argument)
  $printer.write("\e!0#{TRUE}")
end

# case
# when "NORMAL"
#   return 0
# when "REVERSE"
#   return 1
# when "EMPHASIZED"
#   return
# when "REVERSE"
#   return 1
# end
#
#
# BIT1: 1: Reverse mode selected
#  0: Reverse mode not selected
# BIT2: 1: Updown mode selected
#  2: Updown mode not selected
# BIT3: 1:Emphasized mode selected
#  0:Emphasized mode not selected
# BIT4: 1:Double Height mode selected
#  0:Double Height mode not selected
# BIT5: 1:Double Width mode selected
#  0:Double Width mode not selected
# BIT6: 1:Deleteline mode selected
#  0:Deleteline mode not selected

array = []

mode("TEST", 0)
mode("TEST", 1)
mode("TEST", 2)
mode("TEST", 3)

#
# while TRUE
#   var = gets.chomp()
#   if var == "PRINT"
#     break
#   elsif var == "BOLD"
#     bold(gets.chomp)
#   elsif var == "ALIGN"
#     align("right", "right")
#     $printer.puts "test normal"
#     align("center", "center")
#   elsif var == "INVERT"
#     invert(gets.chomp)
#   elsif var == "UNDERLINE"
#     underline(gets.chomp)
#   elsif "TEST"
#     [0,1,2,3,4,5,6].each do |n|
#       mode("testowy string", "BIT#{n}")
#     end
#   else
#     array << go_english(var)
#   end
# end
#
# $printer.puts array
