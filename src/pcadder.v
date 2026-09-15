module pcadder (
    input [31:0] pc_out,    // The current address from the PC register
    input [31:0] imm_out,   // The offset from ImmGen (how far to jump)
    input branch,           // From Control: "Is this a branch instruction?"
    input zeroflag,         // From ALU: "Is the condition met (e.g., rs1 == rs2)?"
    output reg [31:0] pc_next // The final decision sent back to PC input
);

    // Internal wires for our two possible paths
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire mux_decider;

    // Calculate both destinations simultaneously
    assign pc_plus_4 = pc_out + 4;             // Path A: Just go to the next line
    assign branch_target = pc_out + imm_out;   // Path B: Jump to the offset address

    // The logic gate: We only jump if it's a branch AND the math matches (ZeroFlag)
    assign mux_decider = branch && zeroflag;

    always @(*) begin
        // If the decider is 1, take the Jump Path. If 0, take the +4 Path.
        if (mux_decider) begin
            pc_next = branch_target;
        end 
        else begin
            pc_next = pc_plus_4;
        end
    end

endmodule