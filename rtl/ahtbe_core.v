module ahtbe_core (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid,
    input  wire        ready,
    output reg  [7:0]  queue_level,
    output reg         congestion,
    output reg         backpressure
);
    reg [9:0] queue_sum;     // accumulator
    reg [7:0] queue_avg;     // averaged queue level
    // Queue level tracking
    always @(posedge clk) begin
        if (!rst_n)
            queue_level <= 0;
        else begin
            if (valid && !ready)
                queue_level <= queue_level + 1;
            else if (!valid && ready && queue_level > 0)
                queue_level <= queue_level - 1;
        end
    end
// Moving average over last 4 samples
always @(posedge clk) begin
    if (!rst_n) begin
        queue_sum <= 0;
        queue_avg <= 0;
    end else begin
        queue_sum <= queue_sum + queue_level - queue_avg;
        queue_avg <= queue_sum >> 2;  // divide by 4
    end
end

always @(posedge clk) begin
    if (!rst_n)
        congestion <= 0;
    else begin
        // Hysteresis-based congestion control
        if (!congestion && queue_avg >= 8'd4)
            congestion <= 1;
        else if (congestion && queue_avg <= 8'd2)
            congestion <= 0;
    end
end

    // Backpressure generation
    always @(posedge clk) begin
        if (!rst_n)
            backpressure <= 0;
        else
            backpressure <= congestion;
    end

endmodule
