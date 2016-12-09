import printer
import time
from PIL import Image, ImageDraw

p=printer.ThermalPrinter(serialport="/dev/ttyAMA0")

while True:
        com = raw_input().rstrip('\n')
        print com
        if com == "BREAK":
                break
        else:
                image = Image.open(com)
                data = list(image.getdata())
                w, h = image.size
                p.print_bitmap(data, w, h)