module main (
    input cpu_clk,
    input cpu_reset   
);
    // --- INTERNAL WIRING ---
    wire [31:0] next_pc;
    wire [31:0] pc_to_instr;
    wire [31:0] full_instr;
    
    wire [31:0] reg_data1;
    wire [31:0] reg_data2;
    wire [31:0] imm_val;
    
    wire [31:0] alu_input2;
    wire [31:0] alu_output;
    
    wire [3:0]  alu_op;
    wire        reg_bit;
    wire        wire_branch;
    wire        zero_bit;
    wire        alu_src_bit;

    // --- MODULE INSTANTIATION ---

    pc my_pc (
        .clk(cpu_clk),
        .reset(cpu_reset),
        .pc_in(next_pc),
        .pc_out(pc_to_instr)
    );

    pcadder my_adder (
        .pc_out(pc_to_instr),
        .imm_out(imm_val),
        .branch(wire_branch),
        .zeroflag(zero_bit),
        .pc_next(next_pc)
    );

    instrmem my_mem (
        .pc_out(pc_to_instr),
        .instruction(full_instr) 
    );

    regfile my_regs (
        .clk(cpu_clk),
        .reset(cpu_reset),
        .reg_write(reg_bit),
        .rd(full_instr[11:7]),
        .rs1(full_instr[19:15]),
        .rs2(full_instr[24:20]),
        .write_data(alu_output),
        .read_data1(reg_data1),
        .read_data2(reg_data2)   
    );

    control my_brain (
        .opcode(full_instr[6:0]),
        .rd(full_instr[11:7]),
        .funct3(full_instr[14:12]),
        .rs1(full_instr[19:15]),
        .rs2(full_instr[24:20]),
        .funct7(full_instr[31:25]),
        .op(alu_op),
        .reg_write(reg_bit),
        .branch(wire_branch),
        .alu_src(alu_src_bit)    
    );

    alu my_math (
        .A(reg_data1),
        .B(alu_input2),
        .op(alu_op),
        .C(alu_output),
        .zeroflag(zero_bit)      
    );

    imgen my_numbers (
        .instruction(full_instr),
        .imm_out(imm_val)        
    );

    assign alu_input2 = (alu_src_bit == 1'b1) ? imm_val : reg_data2;

endmodule
