----------------------------------------------------------------------------------
-- Create Date: 12.05.2023 20:11:39
-- Design Name: 
-- Module Name: hamming_encoder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
         message <= "010101110000011";
        wait for 10 ns;
         message <= "011110000110101";
   end process;
    
end Behavioral;