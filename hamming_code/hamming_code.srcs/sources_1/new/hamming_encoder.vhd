----------------------------------------------------------------------------------
-- Create Date: 12.05.2023 18:28:34
-- Design Name: hamming_encoder
-- Module Name: hamming_encoder - Behavioral
-- Project Name: hamming_code
-- Description: Parallel implementation of the hamming encoder for [20,15]
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

entity hamming_encoder is
    Port ( 
        m        :  in std_logic_vector(14 downto 0);   -- initial message
        codeWord :  out std_logic_vector(19 downto 0)   -- codeword (coded message)
        );
end hamming_encoder;

------------ Parity bits - Number of parity bits:
-- 2^p >= (p + m) + 1 
-- p = 5 => 32 >= 5 + 15 + 1
-- Parity bits = 5
------------ Parity bits - Position the of parity bits:
-- 2^0 - 1 = 0 => position p0
-- 2^1 - 1 = 1 => position p1
-- 2^2 - 1 = 3 => position p3
-- 2^3 - 1 = 7 => position p7
-- 2^4 - 1 = 15 => position p15
------------ Parity bits - parity bits values:
-- even parity 

architecture Behavioral of hamming_encoder is
    signal p0   :  std_logic;  -- represents the parity bit at position 0
    signal p1   :  std_logic;  -- represents the parity bit at position 1
    signal p3   :  std_logic;  -- represents the parity bit at position 3
    signal p7   :  std_logic;  -- represents the parity bit at position 7
    signal p15  :  std_logic;  -- represents the parity bit at position 15
    
    signal s_codeword : std_logic_vector(19 downto 0);

begin
p0 <= m(0) xor m(1) xor m(3) xor m(4) xor m(6) xor m(8) xor m(10) xor m(11) xor m(13);
p1 <= m(0) xor m(2) xor m(3) xor m(5) xor m(6) xor m(9) xor m(10) xor m(12) xor m(13);
p3 <= m(1) xor m(2) xor m(3) xor m(7) xor m(8) xor m(9) xor m(10) xor m(14);
p7 <= m(4) xor m(5) xor m(6) xor m(7) xor m(8) xor m(9) xor m(10);
p15 <= m(11) xor m(12) xor m(13) xor m(14);

-- positions: 19  18  17  16  15 14  13 12 11 10 9  8  7  6  5  4  3  2  1  0
-- codeWord: m14 m13 m12 m11 p15 m10 m9 m8 m7 m6 m5 m4 p7 m3 m2 m1 p3 m0 p1 p0
s_codeword <= m(14) & m(13) & m(12) & m(11) & 
            p15 & 
            m(10) & m(9) & m(8) & m(7) & m(6) & m(5) & m(4) & 
            p7 & 
            m(3) & m(2) & m(1) & 
            p3 & 
            m(0) &
            p1 & p0; 
codeWord <= s_codeword;

end Behavioral;