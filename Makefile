target = test
srcdir = src
#CC = /opt/cross_toolchain-4.9.2/bin/arm-none-eabi-gcc
#LD = /opt/cross_toolchain-4.9.2/bin/arm-none-eabi-ld
#OBJCOPY = /opt/cross_toolchain-4.9.2/bin/arm-none-eabi-objcopy
CC = arm-linux-gcc
LD = arm-linux-ld
OBJCOPY = arm-linux-objcopy

src = $(wildcard $(srcdir)/*.s)
obj = $(patsubst %.s, %.o, $(src))
$(target).imx:$(obj)
	#@echo $(src)
	#@echo $(obj)
	$(LD) -T$(target).lds $^ -o $(target).elf
	$(OBJCOPY) -O binary $(target).elf $(target).imx
	
%.o:%.s
	$(CC) -c $< -o $@
	
burn:
	dd if=/dev/zero of=/dev/sdb bs=1k seek=4 count=10
	dd if=$(target).imx of=/dev/sdb bs=1k seek=4 conv=fsync

clean:
	@rm $(obj) $(target).elf $(target).imx -rf
