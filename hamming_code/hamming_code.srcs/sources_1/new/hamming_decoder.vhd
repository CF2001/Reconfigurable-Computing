----------------------------------------------------------------------------------
-- Create Date: 20.05.2023 11:22:07
-- Design Name:  hamming_decoder
-- Module Name: hamming_decoder - Behavioral
-- Project Name: hamming_code
-- Description:  Parallel implementation of the hamming decoder for [20,15]
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

------------ Parity bits - Number of parity bits:
-- 2^p >= (p + m) + 1 
-- (p+m) = 20 => 2^p >= 21 logo p = 5
-- Parity bits = 5
------------ Parity bits - Position the of parity bits:
-- 2^0 - 1 = 0 => position p0
-- 2^1 - 1 = 1 => position p1
-- 2^2 - 1 = 3 => position p3
-- 2^3 - 1 = 7 => position p7
-- 2^4 - 1 = 15 => position p15

entity hamming_decoder is
    Port ( 
        codeWord  : in std_logic_vector(19 downto 0);
        m_valid   : out std_logic_vector(16 downto 0) -- 00(valid)/01(single-error)/10(more than one error) + 14to0(data)
    );
end hamming_decoder;

architecture Behavioral of hamming_decoder is
    signal p0, p1, p3, p7, p15   :  std_logic;  -- parity bit at position 0,1,3,7,15 (p0,p1,p3,p7,p15)
    signal c0, c1, c2, c3, c4  :  std_logic;    -- check the parity bit at position 0,1,3,7,15 (p0,p1,p3,p7,p15)
    signal c : std_logic_vector(4 downto 0);    -- all parity bits 
    signal s_overallParity  : std_logic := '0';        -- overall parity bit
    signal s_m              : std_logic_vector(14 downto 0);    -- received message (data bits)
    
begin
-- positions: 19  18  17  16  15 14  13 12 11 10 9  8  7  6  5  4  3  2  1  0
-- codeWord: m14 m13 m12 m11 p15 m10 m9 m8 m7 m6 m5 m4 p7 m3 m2 m1 p3 m0 p1 p0

p0 <= codeWord(0);
p1 <= codeWord(1);
p3 <= codeWord(3);
p7 <= codeWord(7);
p15 <= codeWord(15);

-- CHECKER BIT GENERATOR
c0 <= p0 xor codeWord(2) xor codeWord(4) xor codeWord(6) xor codeWord(8) xor 
    codeWord(10) xor codeWord(12) xor codeWord(14) xor codeWord(16) xor codeWord(18);
c1 <= p1 xor codeWord(2) xor codeWord(5) xor codeWord(6) xor codeWord(9) xor 
    codeWord(10) xor codeWord(13) xor codeWord(14) xor codeWord(17) xor codeWord(18);
c2 <= p3 xor codeWord(4) xor codeWord(5) xor codeWord(6) xor codeWord(11) xor 
    codeWord(12) xor codeWord(13) xor codeWord(14) xor codeWord(19);
c3 <= p7 xor codeWord(8) xor codeWord(9) xor codeWord(10) xor codeWord(11) xor 
    codeWord(12) xor codeWord(13) xor codeWord(14);
c4 <= p15 xor codeWord(16) xor codeWord(17) xor codeWord(18) xor codeWord(19);

c <= c4 & c3 & c2 & c1 & c0;

s_m <= codeWord(19) & codeWord(18) & codeWord(17) & codeWord(16) &
       codeWord(14) & codeWord(13) & codeWord(12) & codeWord(11) &
       codeWord(10) & codeWord(9) & codeWord(8) & codeWord(6) & 
       codeWord(5) & codeWord(4) & codeWord(2);

-- Determine overall parity bit 
s_overallParity <= codeWord(19) xor codeWord(18) xor codeWord(17) xor codeWord(16) xor
       codeWord(15) xor codeWord(14) xor codeWord(13) xor codeWord(12) xor codeWord(11) xor
       codeWord(10) xor codeWord(9) xor codeWord(8) xor codeWord(7) xor codeWord(6) xor 
       codeWord(5) xor codeWord(4) xor codeWord(3) xor codeWord(2) xor codeWord(1) xor codeWord(0);

-- Check message and correct and detect error 
process(c, s_overallParity, s_m)
begin
    if (c = "00000") then -- There is no error in the transmitted codeword, so the codeword is taken as valid information. 
        m_valid <= "00" & s_m;   
    else
        if (s_overallParity = '1') then     -- A single bit error occurred that can be detected and corrected. 
           case c is
                when "00011" => m_valid <= "01" & (s_m xor  "000000000000001");  -- correct bit m0
                when "00101" => m_valid <= "01" & (s_m xor  "000000000000010");  -- correct bit m1
                when "00110" => m_valid <= "01" & (s_m xor  "000000000000100");  -- correct bit m2
                when "00111" => m_valid <= "01" & (s_m xor  "000000000001000");  -- correct bit m3
                when "01001" => m_valid <= "01" & (s_m xor  "000000000010000");  -- correct bit m4
                when "01010" => m_valid <= "01" & (s_m xor  "000000000100000");  -- correct bit m5
			    when "01011" => m_valid <= "01" & (s_m xor  "000000001000000");  -- correct bit m6
			    when "01100" => m_valid <= "01" & (s_m xor  "000000010000000");  -- correct bit m7
			    when "01101" => m_valid <= "01" & (s_m xor  "000000100000000");  -- correct bit m8
			    when "01110" => m_valid <= "01" & (s_m xor  "000001000000000");  -- correct bit m9
			    when "01111" => m_valid <= "01" & (s_m xor  "000010000000000");  -- correct bit m10
			    when "10001" => m_valid <= "01" & (s_m xor  "000100000000000");  -- correct bit m11
			    when "10010" => m_valid <= "01" & (s_m xor  "001000000000000");  -- correct bit m12
			    when "10011" => m_valid <= "01" & (s_m xor  "010000000000000");  -- correct bit m13
			    when "10100" => m_valid <= "01" & (s_m xor  "100000000000000");  -- correct bit m14
			    when others  => m_valid <= (others => '0');
            end case;
        elsif (s_overallParity = '0') then  -- Double bit error occurred that cannot be corrected, so the codeword is taken as invalid information.
            m_valid <= "10" & s_m;
        end if;
    end if;
end process;

end Behavioral;
