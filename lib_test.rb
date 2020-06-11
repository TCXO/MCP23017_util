require './MCP23017.rb'

ADDRESS = 0x20

@keyboard = MCP23017.new(address: 0x20, i2c_bus: 1)
@keyboard.all_input_pullup_on
@keyboard.get_all_input

pullup_count = 0
1000.times do |item|
    @keyboard.get_all_input
    # puts 'wow!' if @keyboard.GPIOAB_tf.include?(true)

    case true
    when @keyboard.GPIOAB_tf[0]
        puts 'aa'
    when @keyboard.GPIOAB_tf[1]
        puts 'bb'
    when @keyboard.GPIOAB_tf[2]
        puts 'cc'
    when @keyboard.GPIOAB_tf[3]
        puts 'dd'
    when @keyboard.GPIOAB_tf[4]
        puts 'ee'
    when @keyboard.GPIOAB_tf[5]
        puts 'ff'
    when @keyboard.GPIOAB_tf[6]
        puts 'gg'
    when @keyboard.GPIOAB_tf[7]
        puts 'bb'
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
