----------------------------------------------------------------------------------
-- Create Date: 28.05.2023 16:17:44
-- Design Name: 
-- Module Name: ErrorDetectionCorrection - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:  
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ErrorDetectionCorrection is
end ErrorDetectionCorrection;

architecture Behavioral of ErrorDetectionCorrection is
    component hamming_encoder
        port(
            m        :  in std_logic_vector(14 downto 0);   -- initial message
            codeWord :  out std_logic_vector(19 downto 0)   -- codeword (coded message)
        );
    end component;
    
    component hamming_decoder
        port(
            codeWord :  in std_logic_vector(19 downto 0);   -- codeword (coded message)
            m_valid :  out std_logic_vector(16 downto 0));   -- validation + message 
    end component;
    
    signal message : std_logic_vector(14 downto 0);
    signal codewordOut : std_logic_vector(19 downto 0);
    
    signal codewordIn : std_logic_vector(19 downto 0);
    signal s_mValid : std_logic_vector(16 downto 0);
    
    -- signal s_sigleError : std_logic_vector(19 downto 0);
begin

       uutEnc : hamming_encoder PORT MAP ( m => message,
                                           codeWord => codewordOut);
                                     
       uutDec : hamming_decoder PORT MAP ( codeWord => codewordIn,
                                           m_valid => s_mValid);
                                          
                                     
    comb_process: process      
    begin
        message <= "110110111010001";
        wait for 10 ns;
        codewordIn <= codewordOut;      -- message without errors
        wait for 50 ns;
        codewordIn <= (codewordOut xor "0000000000000000100"); -- message with a single error (bit m0)
        wait for 50 ns;
        codewordIn <= (codewordOut xor "0000000000000010000"); -- message with a single error (bit m1)
        wait for 50 ns;
        codewordIn <= (codewordOut xor "0000000000000100000"); -- message with a single error (bit m2)
        wait for 50 ns;
        codewordIn <= (codewordOut xor "0000000000001000000"); -- message with a single error (bit m3)
        wait for 50 ns; 
        codewordIn <= (codewordOut xor "1000000000000100000"); -- message with a double error (bit m14 + m2)
        wait for 50 ns;
    end process;
end Behavioral;
