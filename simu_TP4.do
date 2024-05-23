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
vsim TopLevel_tb

# 查看信号
view signals 
add wave -radix hexadecimal *
add wave -radix hexadecimal sim:/toplevel_tb/uut/busW
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/instruction_memory
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/Banc 
add wave -radix hexadecimal sim:/toplevel_tb/uut/I1D_inst/instruction
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/instruction
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/PC
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/Rd
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/Rn
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/Rm
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/imm8
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/B
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/A
add wave -radix hexadecimal sim:/toplevel_tb/uut/MUX3_inst/COM
add wave -radix hexadecimal sim:/toplevel_tb/uut/MUX3_inst/S
#add wave -radix hexadecimal 

# 运行仿真
run -all

