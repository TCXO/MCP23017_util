require './MCP23017.rb'
require 'pi_piper'
require 'i2c'

ADDRESS = 0x20

@keyboard = MCP23017.new(address: 0x20, i2c_bus: 1)
@keyboard.all_input_pullup_on
@keyboard.get_all_input

@i2c_device = I2C.create("/dev/i2c-1")
# @i2c_device.write(0x24, '00:00:00:00')
# @i2c_device.write(0x24, '14:29:57:00')
# sleep 3
# @i2c_device.write(0x24, 'cmd:left')
# sleep 1
# @i2c_device.write(0x24, 'cmd:up')
# sleep 1
# @i2c_device.write(0x24, 'cmd:down')
# sleep 1
# @i2c_device.write(0x24, 'cmd:right')
# sleep 1
# @i2c_device.write(0x24, '01:19:00:00')
# @i2c_device.write(0x24, 'cmd:right')


pullup_count = 0
# 1cycle = 0.1s
1000.times do |item|
    @keyboard.get_all_input

    case true
    when @keyboard.GPIOAB_tf[0]
        puts 'GPA0'
    when @keyboard.GPIOAB_tf[1]
        puts 'GPA1'
        @i2c_device.write(0x24, 'cmd:up')
    when @keyboard.GPIOAB_tf[2]
        puts 'GPA2'
    when @keyboard.GPIOAB_tf[3]
        puts 'GPA3'
        @i2c_device.write(0x24, 'cmd:left')
    when @keyboard.GPIOAB_tf[4]
        puts 'GPA4'
        @i2c_device.write(0x24, 'cmd:down')
    when @keyboard.GPIOAB_tf[5]
        puts 'GPA5'
        @i2c_device.write(0x24, 'cmd:right')
    when @keyboard.GPIOAB_tf[6]
        puts 'GPA6'
    when @keyboard.GPIOAB_tf[7]
        puts 'GPA7'
    when @keyboard.GPIOAB_tf[8]
        puts 'GPB0'
        @i2c_device.write(0x24, '00:00:00:00')
    when @keyboard.GPIOAB_tf[9]
        puts 'GPB1'
    when @keyboard.GPIOAB_tf[10]
        puts 'GPB2'
    when @keyboard.GPIOAB_tf[11]
        puts 'GPB3'
    when @keyboard.GPIOAB_tf[12]
        puts 'GPB4'
    when @keyboard.GPIOAB_tf[13]
        puts 'GPB5'
    when @keyboard.GPIOAB_tf[14]
        puts 'GPB6'
    when @keyboard.GPIOAB_tf[15]
        puts 'GPB7'
    else
        pullup_count = pullup_count + 1
        
        # 10s毎にPullupをReset
        if pullup_count == 100
            @keyboard.all_input_pullup_on
            pullup_count = 0
            puts 'pullup reset!'
        end
    end
end
