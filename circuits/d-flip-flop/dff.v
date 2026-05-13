module dff (
    input  wire clk,
    input  wire rst_n,
    input  wire d,
    output reg  q
);

    // Ideal: no delay
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= #1 1'b0;  // small delay for visibility
        else
            q <= #1 d;
    end

    // Timing checks (for simulation only)
    specify
        $setup(d, posedge clk, 1.0);   // t_su = 1 ns
        $hold(posedge clk, d, 0.5);    // t_h = 0.5 ns
    endspecify

endmodule