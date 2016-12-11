import printer
import time
from PIL import Image, ImageDraw

p=printer.ThermalPrinter(serialport="/dev/ttyAMA0")

com = 'demo.bmp'
image = Image.open(com)
data = list(image.getdata())
print(data)
p.print_bitmap(data, 384, 1)