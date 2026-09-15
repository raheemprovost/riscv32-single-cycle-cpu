module pc (
    input clk,
    input reset,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        if (reset) begin
            // What happens when you reboot?
            pc_out <= 32'b0;
        end
        else begin
            // What happens on every normal beat?
            pc_out <= pc_in;
        end
    end

endmodule