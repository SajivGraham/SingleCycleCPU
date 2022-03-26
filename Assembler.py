text_file = open(r'C:\Users\saj-2\Desktop\TEST.txt')
text2 = open(r'C:\Users\saj-2\Desktop\MACHINE.txt', 'w')
all_lines = text_file.readlines()

length1 = len(all_lines)
i = 0

ARRAY = ('PROGRAM_MEMORY_ARRAY(')
ARRAY2 = (') <= "')
ARRAY3 = ('";')

def two_reg_no_dest(split_line, entire_opcode_bits, loop_bit):  # when r1 and r2 is used with no rd
    split_line2 = split_line[1].split("R")
    split_line3 = split_line2[1].split(",")
    reg_1_str = split_line3[0]
    reg_1_int = int(reg_1_str) - 1

    split_line2 = split_line[2].split("R")
    split_line3 = split_line2[1].split(",")
    reg_2_str = split_line3[0]
    reg_2_int = int(reg_2_str) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(reg_1_int))
    text2.writelines("{:04b}".format(reg_2_int))
    text2.writelines("{:012b}".format(0) + ARRAY3 + " ")
    
def imm_instruction(split_line, entire_opcode_bits, loop_bit): #when 16 bit immediate val is used as well as rd

    split_line2 = split_line[1].split()
    split_line3 = split_line2[0].split(",")
    split_line4 = split_line3[0].split("R")
    immediate_reg_num_str = split_line4[1]
    immediate_reg_num_int = int(immediate_reg_num_str) - 1
    split_line5 = split_line[2].split()
    immediate_val_str = split_line5[0]

    text2.writelines(ARRAY + str(i) + ARRAY2)
    immediate_val_int = int(immediate_val_str)
    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:016b}".format(immediate_val_int))
    text2.writelines("{:04b}".format(immediate_reg_num_int) + ARRAY3 + " ")
    
def non_imm(split_line,entire_opcode_bits,loop_bit):  # when r1, r2, rd can be different
    split_line2 = split_line[1].split("R")
    split_line3 = split_line2[1].split(",")
    dest_reg = split_line3[0]
    dest_reg_int = int(dest_reg) - 1

    split_line2 = split_line[2].split("R")
    split_line3 = split_line2[1].split(",")
    reg_1 = split_line3[0]
    reg_1_int =  int(reg_1) - 1


    split_line2 = split_line[3].split("R")
    reg_2 = split_line2[1]
    reg_2_int = int(reg_2) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(reg_1_int))
    text2.writelines("{:04b}".format(reg_2_int))
    text2.writelines("{:08b}".format(0))
    text2.writelines("{:04b}".format(dest_reg_int)+ ARRAY3 + " ")

def one_register_addressing(split_line,entire_opcode_bits,loop_bit):  # when using r2 and rd only
    split_line2 = split_line[1].split("R")
    dest_reg_str = split_line2[1]
    reg_2_str = split_line2[1]
    dest_reg_int = int(dest_reg_str) - 1
    reg_2_int = int(reg_2_str) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(0))
    text2.writelines("{:04b}".format(reg_2_int))
    text2.writelines("{:08b}".format(0))
    text2.writelines("{:04b}".format(dest_reg_int) +ARRAY3 + " ")

def MOV(split_line,entire_opcode_bits,loop_bit):
    split_line2 = split_line[1].split(",")
    split_line3 = split_line2[0].split("RAM")
    ram_addr_int = int(split_line3[1]) - 1

    split_line2 =  split_line[2].split("R")
    reg_addr_int = int(split_line2[1]) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(0))
    text2.writelines("{:04b}".format(reg_addr_int))
    text2.writelines("{:08b}".format(ram_addr_int))
    text2.writelines("{:04b}".format(0) + ARRAY3 + " ")

def INPUT(split_line,entire_opcode_bits,loop_bit):
    split_line2 = split_line[1].split("R")
    reg_addr_int = int(split_line2[1]) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:016b}".format(0))
    text2.writelines("{:04b}".format(reg_addr_int) + ARRAY3 + " ")
def OUTPUT(split_line,entire_opcode_bits,loop_bit):
    split_line2 = split_line[1].split("R")
    reg_addr_int = int(split_line2[1]) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(0))
    text2.writelines("{:04b}".format(reg_addr_int))
    text2.writelines("{:012b}".format(0) + ARRAY3 + " ")

def STRREG(split_line,entire_opcode_bits,loop_bit):
    split_line2 = split_line[1].split(",")
    split_line3 = split_line2[0].split("ROM")
    rom_addr_int = int(split_line3[1]) - 1

    split_line2 = split_line[2].split("R")
    reg_addr_int = int(split_line2[1]) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(0))
    text2.writelines("{:04b}".format(reg_addr_int))
    text2.writelines("{:08b}".format(rom_addr_int))
    text2.writelines("{:04b}".format(0) + ARRAY3 + " ")
    
def STRRAM(split_line,entire_opcode_bits,loop_bit):
    split_line2 = split_line[1].split(",")
    split_line3 = split_line2[0].split("ROM")
    rom_addr_int = int(split_line3[1]) - 1

    split_line2 = split_line[2].split("RAM")
    ram_addr_int = int(split_line2[1]) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(0))
    text2.writelines("{:08b}".format(rom_addr_int))
    text2.writelines("{:04b}".format(0) + ARRAY3 + " ")
    
def just_opcode(entire_opcode_bits,loop_bit):
    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:020b}".format(0) + ARRAY3 + " ")

def BRANCHES(entire_opcode_bits,loop_bit):
    split_line2 = split_line[1].split("R")
    split_line3 = split_line2[1].split(",")
    reg_1_str = split_line3[0]
    reg_1_int = int(reg_1_str) - 1

    split_line2 = split_line[2].split("R")
    split_line3 = split_line2[1].split(",")
    reg_2_str = split_line3[0]
    reg_2_int = int(reg_2_str) - 1

    entire_opcode_bits = entire_opcode_bits + loop_bit
    text2.writelines(ARRAY + str(i) + ARRAY2)
    text2.writelines(entire_opcode_bits)
    text2.writelines("{:04b}".format(reg_1_int))
    text2.writelines("{:04b}".format(reg_2_int))
    text2.writelines("{:012b}".format(0) + ARRAY3 + " ")

while i < (length1):
    line = all_lines[i]
    split_line = line.split()

    if split_line[0] == "LOOP1:":
        opcode = split_line[1]
        loop_bit = '001'
        split_line.remove(split_line[0])
        print(split_line)

    elif split_line[0] == "LOOP2:":
        opcode = split_line[1]
        loop_bit = '010'
        split_line.remove(split_line[0])
        print(split_line)

    elif split_line[0] == "LOOP3:":
        opcode = split_line[1]
        loop_bit = '011'
        split_line.remove(split_line[0])

    elif split_line[0] == "LOOP4:":
        opcode = split_line[1]
        loop_bit = '100'
        split_line.remove(split_line[0])

    elif split_line[0] == "LOOP5:":
        opcode = split_line[1]
        loop_bit = '101'
        split_line.remove(split_line[0])

    elif split_line[0] == "LOOP6:":
        opcode = split_line[1]
        loop_bit = '110'
        split_line.remove(split_line[0])

    elif split_line[0] == "LOOP7:":
        opcode = split_line[1]
        loop_bit = '111'
        split_line.remove(split_line[0])

    else:
        opcode = split_line[0]
        loop_bit = '000'


    if opcode == "ADDIMM":
        entire_opcode_bits = '00000100'
        imm_instruction(split_line, entire_opcode_bits, loop_bit)


    elif opcode == "ADD":
        entire_opcode_bits = '00000000'
        non_imm(split_line, entire_opcode_bits, loop_bit)


    elif opcode == "SUBIMM":
        entire_opcode_bits = '00001100'
        imm_instruction(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "SUB":
        entire_opcode_bits = '00001000'
        non_imm(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "MULIMM":
        entire_opcode_bits = '00010100'
        imm_instruction(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "MUL":
        entire_opcode_bits = '00010000'
        non_imm(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "DIVIMM":
        entire_opcode_bits = '00011100'
        imm_instruction(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "DIV":
        entire_opcode_bits = '00011000'
        non_imm(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "INC":
        entire_opcode_bits = '00100000'
        one_register_addressing(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "DEC":
        entire_opcode_bits = '00101000'
        one_register_addressing(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "CLR":
        entire_opcode_bits = '00110000'
        one_register_addressing(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "CMP":
        entire_opcode_bits = '00111000'
        two_reg_no_dest(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "LSL":
        entire_opcode_bits = '01000000'

    elif opcode == "LSR":
        entire_opcode_bits = '01001000'

    elif opcode == "LOGAND":
        entire_opcode_bits = '01010000'
        two_reg_no_dest(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "LOGOR":
        entire_opcode_bits = '01011000'
        two_reg_no_dest(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "LOGXOR":
        entire_opcode_bits = '01100000'
        two_reg_no_dest(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "BITAND":
        entire_opcode_bits = '01101000'
        non_imm(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "BITOR":
        entire_opcode_bits = '01110000'
        non_imm(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "BITXOR":
        entire_opcode_bits = '01111000'
        non_imm(split_line, entire_opcode_bits, loop_bit)

    if opcode == "ONES":
        entire_opcode_bits = '10000100'
        one_register_addressing(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "TWOS":
        entire_opcode_bits = '10001000'
        one_register_addressing(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "LOAD":
        entire_opcode_bits = '10010100'
        imm_instruction(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "MOV":
        entire_opcode_bits = '10011010'
        MOV(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "CPY":
        entire_opcode_bits = '10100000'
        one_register_addressing(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "STRREG":
        entire_opcode_bits = '10101001'
        STRREG(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "STRRAM":
        entire_opcode_bits = '10101011'
        STRRAM(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "INPUT":
       entire_opcode_bits = '10110000'
       INPUT(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "OUTPUT":
        entire_opcode_bits = '11000000'
        OUTPUT(split_line, entire_opcode_bits, loop_bit)

    elif opcode == "CLRSTS":
        entire_opcode_bits = '11000000'
        just_opcode(entire_opcode_bits, loop_bit)

    elif opcode == "JUMP":
        entire_opcode_bits = '11010000'
        just_opcode(entire_opcode_bits, loop_bit)

    elif opcode == "BRNEQ":
        entire_opcode_bits = '11011000'
        non_imm(split_line,entire_opcode_bits,loop_bit)

    elif opcode == "BRNNEQ":
        entire_opcode_bits = '11100000'
        non_imm(split_line,entire_opcode_bits,loop_bit)

    elif opcode == "BRNG":
        entire_opcode_bits = '11101000'
        non_imm(split_line,entire_opcode_bits,loop_bit)

    elif opcode == "BRNL":
        entire_opcode_bits = '11110000'
        non_imm(split_line,entire_opcode_bits,loop_bit)

    elif opcode == "NOP":
        entire_opcode_bits = '11111000'
        just_opcode(entire_opcode_bits, loop_bit)
    text_file.close()
    i = i + 1
text2.close()
