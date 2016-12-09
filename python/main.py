import printer
import time
from PIL import Image, ImageDraw

p=printer.ThermalPrinter(serialport="/dev/ttyAMA0")
i1 = Image.open("1.png")
i2 = Image.open("2.png")
i3 = Image.open("3.png")
data = list(i1.getdata())
w, h = i1.size
p.print_bitmap(data, w, h)

p.print_text(" ")
p.print_text(" ")

time.sleep(15)

data = list(i2.getdata())
w, h = i2.size
p.print_bitmap(data, w, h)

p.print_text(" ")
p.print_text(" ")

time.sleep(15)

data = list(i3.getdata())
w, h = i3.size
p.print_bitmap(data, w, h)
