

print(gpio.read(3))
gpio.write(3,not(gpio.read(3) == 0) and 0 or 1)
print(gpio.read(3))