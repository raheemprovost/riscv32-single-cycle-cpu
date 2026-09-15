module control (
    input [6:0] opcode,
    input [4:0] rd,
    input [2:0] funct3,
    input [4:0] rs1,
    input [4:0] rs2,
    input [6:0] funct7,
    output reg reg_write,   // High if we need to save a result to x1-x31
    output reg mem_write,   // High for 'sw' (Store Word) instructions
    output reg alu_src,     // 0 = Use Register rs2, 1 = Use Immediate
    output reg [1:0] op_hint, // 00=Load/Store, 01=Branch, 10=Math
    output reg [3:0] op,    // The specific 4-bit command for the ALU
    output reg branch
);

    // --- MAIN CONTROL DECODER ---
    // Figures out the general type of instruction using the Opcode
    always @(*) begin
        if (opcode == 7'b0110011) begin      // R-TYPE (add, sub, and, or)
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_src   = 1'b0;
            op_hint   = 2'b10;
            branch = 1'b0;
        end
        else if (opcode == 7'b0010011) begin // I-TYPE (addi, andi)
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_src   = 1'b1;
            op_hint   = 2'b10;
            branch = 1'b0;

        end
        else if (opcode == 7'b0000011) begin // LOAD (lw)
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_src   = 1'b1;
            op_hint   = 2'b00;
            branch = 1'b0;
        end
        else if (opcode == 7'b0100011) begin // STORE (sw)
            reg_write = 1'b0;
            mem_write = 1'b1;
            alu_src   = 1'b1;
            op_hint   = 2'b00;
            branch = 1'b0;
        end
        else if (opcode == 7'b1100011) begin // BRANCH (beq, bne)
            reg_write = 1'b0;
            mem_write = 1'b0;
            alu_src   = 1'b0;
            op_hint   = 2'b01;
            branch = 1'b1;
        end
        else begin
            // Default: Everything off to prevent accidental memory writes
            reg_write = 1'b0;
            mem_write = 1'b0;
            alu_src   = 1'b0;
            op_hint   = 2'b00;
            branch = 1'b0;
        end
    end

    // --- ALU CONTROL DECODER ---
    // Drills down into funct3/7 to tell the ALU exactly what math to do
    always @(*) begin
        if (op_hint == 2'b00) begin      // LOAD/STORE: Always just ADD
            op = 4'b0010;
        end
        else if (op_hint == 2'b01) begin // BRANCH: Usually just SUB (for comparison)
            op = 4'b0110;
        end
        else if (op_hint == 2'b10) begin // MATH: Check specific operation
            if (funct3 == 3'b111)      op = 4'b0000; // AND
            else if (funct3 == 3'b110) op = 4'b0001; // OR
            else if (funct3 == 3'b010) op = 4'b0111; // SLT (Set Less Than)
            else if (funct3 == 3'b000) begin
                // Special check for ADD vs SUB (bit 30 of instruction)
                if (funct7 == 7'b0000000) op = 4'b0010; // ADD
                else                      op = 4'b0110; // SUB
            end
            else op = 4'b0010; // Default to ADD
        end
        else begin
            op = 4'b0010; // Default to ADD
        end
    end

endmodule