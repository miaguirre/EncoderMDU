----------------------------------------------------------------------------------
-- Company: Universidad de Sevilla
-- Engineer: Miguel A.  Aguirre
-- 
-- Create Date:    00:07:49 11/18/2014 
-- Design Name: ARIN C 429
-- Module Name:    voter - Behavioral 
-- Project Name: SEA2ME
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity voter is
    Port ( in0 : in  STD_LOGIC;
           in1 : in  STD_LOGIC;
           in2 : in  STD_LOGIC;
           out_tmr : out  STD_LOGIC);
end voter;

architecture Behavioral of voter is
begin
			out_tmr <= (in0 and in1) or (in0 and in2) or (in1 and in2);
end Behavioral;

