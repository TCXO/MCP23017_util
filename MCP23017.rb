IODIRA = 0x00
IPOLA = 0x02
GPINTENA = 0x04
DEFVALA = 0x06
INTCONA = 0x08
IOCONA = 0x0A
GPPUA = 0x0C
INTFA = 0x0E
INTCAPA = 0x10
GPIOA = 0x12
OLATA = 0x14


IODIRB = 0x01
IPOLB = 0x03
GPINTENB = 0x05
DEFVALB = 0x07
INTCONB = 0x09
IOCONB = 0x0B
GPPUB = 0x0D
INTFB = 0x0F
INTCAPB = 0x11
GPIOB = 0x13
OLATB = 0x15

class MCP23017
    attr_reader :GPIOA_tf, :GPIOB_tf, :GPIOAB_tf

    def initialize(address: 0x20, i2c_bus: 1)
        @address = address
        @i2c_bus = i2c_bus

        # MCP23017's address range: 0x20..27
        puts "Invalid address, given: #{@address}" unless  @address.between?(32, 39)
        
        cmd_result = %x{sudo i2cdetect -l}
        i2c_busses = cmd_result.split(/\r?\n/).map { |item| item[4, 1].to_i }
        puts "Disable i2c_bus, given: #{@i2c_bus}" unless i2c_busses.include?(i2c_bus)

    end

    def all_input_pullup_on
        %x{sudo i2cset -y #{@i2c_bus} #{@address} 0x0c 0xff}
        %x{sudo i2cset -y #{@i2c_bus} #{@address} 0x0d 0xff}
    end

    # working_time: 0
    def get_all_input
        @GPIOA_bin = %x{sudo i2cget -y #{@i2c_bus} #{@address} 0x12}.hex.to_s(2).rjust(8, '0')
        @GPIOB_bin = %x{sudo i2cget -y #{@i2c_bus} #{@address} 0x13}.hex.to_s(2).rjust(8, '0')
        # puts "@GPIOA_bin: #{@GPIOA_bin}"
        # puts "@GPIOB_bin: #{@GPIOB_bin}"

                
        # true = on =short
        # @GPIOA_tf = @GPIOA_bin.split('').map(&:to_i).map{ |item| item.zero? ? true : false}
        @GPIOA_tf = @GPIOA_bin.split('').map{ |item| item.to_i.zero? ? true : false }.reverse
        @GPIOB_tf = @GPIOB_bin.split('').map{ |item| item.to_i.zero? ? true : false }.reverse
        # puts "@GPIOA_tf: #{@GPIOA_tf}"
        # puts "@GPIOB_tf: #{@GPIOB_tf}"

        @GPIOAB_tf = @GPIOA_tf + @GPIOB_tf
        # puts "@GPIOAB_tf: #{@GPIOAB_tf}"
    end
end
