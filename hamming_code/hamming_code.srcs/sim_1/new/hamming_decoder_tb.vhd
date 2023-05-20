----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 17:32:57
-- Design Name: 
-- Module Name: hamming_decoder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hamming_decoder_tb is
end hamming_decoder_tb;

architecture Behavioral of hamming_decoder_tb is
    component hamming_decoder
        port(
            codeWord :  in std_logic_vector(19 downto 0);   -- codeword (coded message)
            m_valid :  out std_logic_vector(15 downto 0)   -- validation + message 
        );
    end component;
    
    signal codeword : std_logic_vector(19 downto 0);
    signal s_mValid : std_logic_vector(15 downto 0);
begin
    uut : hamming_decoder PORT MAP ( codeWord => codeword,
                                     m_valid => s_mValid);
                                     
   comb_process: process
   begin
         codeWord <= "11011101110110000101";
        wait for 10 ns;
         codeWord <= "11011101110110000101";
        wait for 10 ns;
   end process;
    
end Behavioral;