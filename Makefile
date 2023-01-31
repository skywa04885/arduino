AVR_AS ?= $(shell which avr-as)
AVR_GCC ?= $(shell which avr-gcc)
AVR_LD ?= $(shell which avr-ld)
AVR_OBJCOPY ?= $(shell which avr-objcopy)
AVR_SIZE ?= $(shell which avr-size)
AVR_G++ ?= $(shell which avr-g++)
AVRDUDE ?= $(shell which avrdude)

S_SOURCES = $(shell find ./src -name "*.s")
CPP_SOURCES = $(shell find ./src -name "*.cpp")
C_SOURCES = $(shell find ./src -name "*.c")

OBJECTS = $(S_SOURCES:.s=.s.o)
OBJECTS += $(C_SOURCES:.c=.c.o)
OBJECTS += $(CPP_SOURCES:.cpp=.cpp.o)

ELF_OUT ?= build/main.elf
HEX_OUT ?= build/main.ihex

MCU ?= atmega328p

AVR_AS_ARGUMENTS += -mmcu=$(MCU)

AVR_GCC_ARGUMENTS += -mmcu=$(MCU)
AVR_GCC_ARGUMENTS += -Os
AVR_GCC_ARGUMENTS += -I./inc
AVR_GCC_ARGUMENTS += -DF_CPU=16000000LU

AVR_G++_ARGUMENTS += -mmcu=$(MCU)
AVR_G++_ARGUMENTS += -Os
AVR_G++_ARGUMENTS += -I./inc
AVR_G++_ARGUMENTS += -DF_CPU=16000000LU

AVR_LD_ARGUMENTS += -mmcu=$(MCU)

AVR_OBJCOPY_ARGUMENTS += -O ihex

AVR_SIZE_ARGUMENTS += -C
AVR_SIZE_ARGUMENTS += --mcu=$(MCU)

AVRDUDE_ARGUMENTS += -p $(MCU)
AVRDUDE_ARGUMENTS += -c arduino
AVRDUDE_ARGUMENTS += -U flash:w:$(HEX_OUT)
AVRDUDE_ARGUMENTS += -P /dev/ttyACM0

%.s.o: %.s
	$(AVR_AS) $(AVR_AS_ARGUMENTS) -c $< -o $@

%.c.o: %.c
	$(AVR_GCC) $(AVR_GCC_ARGUMENTS) -c $< -o $@

%.cpp.o: %.cpp
	$(AVR_G++) $(AVR_G++_ARGUMENTS) -c $< -o $@

all: $(OBJECTS)
	mkdir -p build
	$(AVR_LD) $(OBJECTS) -o $(ELF_OUT)
	$(AVR_OBJCOPY) $(AVR_OBJCOPY_ARGUMENTS) $(ELF_OUT) $(HEX_OUT)
	$(AVR_SIZE) $(AVR_SIZE_ARGUMENTS) $(ELF_OUT)
upload: all
	$(AVRDUDE) $(AVRDUDE_ARGUMENTS)
clean:
	rm -rf $(OBJECTS) $(ELF_OUT) $(HEX_OUT)
