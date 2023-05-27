----------------------------------------------------------------------------------
-- Create Date: 12.05.2023 20:11:39
-- Design Name: hamming_encoder
-- Module Name: hamming_encoder_tb - Behavioral
-- Project Name: hmming_code
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hamming_encoder_tb is
end hamming_encoder_tb;

architecture Behavioral of hamming_encoder_tb is
    component hamming_encoder
        port(
            m        :  in std_logic_vector(14 downto 0);   -- initial message
            codeWord :  out std_logic_vector(19 downto 0)   -- codeword (coded message)
        );
    end component;
    
    signal message : std_logic_vector(14 downto 0);
    signal codeword : std_logic_vector(19 downto 0);
begin
    uut : hamming_encoder PORT MAP ( m => message,
                                     codeWord => codeword);
                                     
   comb_process: process
   begin
         message <= "110110111010001";
        wait for 10 ns;
         message <= "110110111010001";
        wait for 10 ns;
   end process;
    
end Behavioral;