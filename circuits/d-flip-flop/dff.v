// dff.v
module dff (
    input  wire clk,
    input  wire rst_n,  // active-low async reset
    input  wire d,
    output reg  q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule