
module packet_parser(
input clk,
input rst,
input data_valid,
input [PACKET_WIDTH - 1:0] packet_data_in,
input start_of_packet,
input end_of_packet,
output reg packet_valid_flag,
output reg [$clog2(MAX_COUNT) - 1 : 0] packet_valid_counter,
output reg packet_error_flag,
output reg [$clog2(MAX_COUNT) - 1 : 0] packet_error_counter
);
parameter PACKET_WIDTH = 32;
parameter MAX_COUNT = 4'b1111;
parameter NUMBER_OF_WORD = 5;
parameter MAX_NUMBER_OF_WORD = 3'b111;

reg [2:0] packet_word_count;
reg start_flag; 

// ------------ Start Flag -------------------------------
always @(posedge clk or negedge rst)
begin 
   if(rst == 1'b0)
   begin
      start_flag <= 1'b0;
      packet_word_count <=  3'b0;
   end
   else 
   begin
      if(start_of_packet == 1'b1 && data_valid == 1'b1)
      begin
         start_flag <= 1'b1;
         packet_word_count <= 3'b1;
      end

      else if(end_of_packet == 1'b1 && data_valid == 1'b1) 
      begin 
          start_flag <= 1'b0;
          packet_word_count <= 3'b0;
      end
      
      else if (packet_word_count == MAX_NUMBER_OF_WORD)
      begin 
         packet_word_count <= MAX_NUMBER_OF_WORD;
      end 
       
      else if((packet_word_count >= NUMBER_OF_WORD - 1) && data_valid  == 1'b1)
      begin
          packet_word_count <=  packet_word_count + 1;
      end 
      
      else if(start_flag == 1'b1 && data_valid  == 1'b1)
      begin
          packet_word_count <= packet_word_count + 1;
      end
       
   end   
end 

// ------------------------- valid packet ----------------- 
// Structure Packet...
// Word size is 32 bit
 
//---------------------
//|      word 0       |
//---------------------
//|      word 1       | packet_valid_flag <= 1'b1;

//---------------------
// packet_valid_flag <= 1'b1;
//|      word 2       |
//---------------------
//|      word 3       |
//---------------------
//|      word 4       |
//---------------------


always @(posedge clk or negedge rst)
begin 
   if(rst == 1'b0)
   begin
      packet_valid_flag <= 1'b0;
      packet_valid_counter <= 4'b0;
   end
   else 
   begin
      if(((end_of_packet == 1'b1 && packet_word_count == NUMBER_OF_WORD - 1 ) && data_valid == 1'b1) &&  packet_valid_counter <  MAX_COUNT)
      begin
         packet_valid_flag <= 1'b1;
         packet_valid_counter <=  packet_valid_counter + 1'b1 ;
      end 

      else if(((end_of_packet == 1'b1 && packet_word_count == NUMBER_OF_WORD - 1) && data_valid == 1'b1) &&  packet_valid_counter >= MAX_COUNT)
      begin
         packet_valid_flag <= 1'b1;
         packet_valid_counter <= MAX_COUNT;
      end 

      else 
      begin 
          packet_valid_flag <= 1'b0;
      end
   end   
end 

// invalid packet or unstructured packet according to the requirement 
 
always @(posedge clk or negedge rst)
begin 
   if(rst == 1'b0)
   begin
     
      packet_error_flag <= 1'b0;
      packet_error_counter <= 4'b0;
   end
   else 
   begin
      if(((end_of_packet == 1'b1 && packet_word_count != NUMBER_OF_WORD - 1 ) && data_valid  == 1'b1) &&  packet_error_counter <  MAX_COUNT)
      begin
         packet_error_flag <= 1'b1;
         packet_error_counter <=  packet_error_counter + 1'b1 ;
      end 

      else if(((end_of_packet == 1'b1 && packet_word_count != NUMBER_OF_WORD - 1) && data_valid  == 1'b1) &&  packet_error_counter >=  MAX_COUNT)
      begin
         packet_error_flag <= 1'b1;
         packet_error_counter <=  MAX_COUNT;
      end 

      else 
      begin 
          packet_error_flag <= 1'b0;
      end

   end   
end 


endmodule 
/*
  if((end_of_packet == 1'b1 && packet_word_count == number_of_word - 1 ) && valid_data == 1'b1)
      begin
         if(packet_valid_counter == max_count)
         begin 
             packet_valid_counter <= max_count;
         end
 
         else
         begin
            packet_valid_flag <= 1'b1;
            packet_invalid_flag <= 1'b0; 
            packet_valid_counter <= packet_valid_counter + 1'b1;
            packet_word_count <= 3'b0;
            start_flag <= 1'b0;
         end
      end

      else if(start_of_packet == 1'b1 && valid_data == 1'b1)
      begin
         if(packet_word_count >=  number_of_word)
         begin
            packet_word_count <= 3'b0;
         end
          start_flag <= 1'b1;
      end

      else if(end_of_packet == 1'b1 && packet_word_count != number_of_word - 1  && valid_data == 1'b1)
      begin
         if(packet_invalid_counter == max_count)
         begin
            packet_invalid_counter <= max_count;
         end 
        
         else
         begin
            packet_valid_flag <= 1'b0;
            packet_invalid_flag <= 1'b1;
            packet_invalid_counter <= packet_invalid_counter + 1'b1;
            packet_word_count <= 3'b0;
            start_flag <= 1'b0;
         end
      end

      else 
      begin 
         packet_valid_flag <= 1'b0;
         packet_invalid_flag <= 1'b0;
         if(start_flag == 1'b1 ) 
         begin 
            packet_word_count <= packet_word_count + 1'b1;
         end 
      end
*/
