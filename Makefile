target = test
srcdir = src
CC = /opt/cross_toolchain-4.9.2/bin/arm-none-eabi-gcc
LD = /opt/cross_toolchain-4.9.2/bin/arm-none-eabi-ld
OBJCOPY = /opt/cross_toolchain-4.9.2/bin/arm-none-eabi-objcopy
src = $(wildcard $(srcdir)/*.s)
obj = $(patsubst %.s, %.o, $(src))
$(target).imx:$(obj)
	#@echo $(src)
	#@echo $(obj)
	$(LD) -T$(target).lds $^ -o $(target).elf
	$(OBJCOPY) -O binary $(target).elf $(target).imx
	
%.o:%.s
	$(CC) -c $< -o $@
	
clean:
	@rm $(obj) $(target).elf $(target).imx -rf