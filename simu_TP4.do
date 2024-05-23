# 创建工作库
# 编译 VHDL 文件
vcom -2008 instruction_memory.vhd
vcom -2008 REG.vhd
vcom -2008 ALU.vhd
vcom -2008 MUX.vhd
vcom -2008 MUX3.vhd
vcom -2008 Data_Memory.vhd


vcom -2008 Immextender.vhd
vcom -2008 Instruction_Management_Unit.vhd
vcom -2008 InstructionDecoder.vhd
vcom -2008 TopLevel_TP4.vhd
vcom -2008 TestBench_tp4.vhd


# 启动仿真
vsim TopLevel_TP4

# 查看信号
view signals 
add wave -radix hexadecimal *

# 运行仿真
run -all

