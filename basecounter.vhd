----------------------------------------------------------------------------------
-- Company: University of Sevilla	
-- Engineer: Miguel A. Aguirre	
-- 
-- Create Date:    12:31:16 11/06/2014 
-- Design Name: ARINC 429 transmitter
-- Module Name:    basecounter - Behavioral 
-- Project Name: 
-- Target Devices: Any 
-- Tool versions: 
-- Description: Base counter for bit transmitter
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
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity basecounter is
--! system clock 100 Mhz
--! N size of counter, Cycle_tbit and Cycle_halfbit are the clock cycles to deteermine the bit size.
	 generic( N : integer := 14; Cycle_tbit : integer := 8000; Cycle_halfbit : integer := 4000);
    Port ( clk : in  STD_LOGIC; --! system clock
           resetz : in  STD_LOGIC; --! master asyschronous reset, active low
           resets : in  STD_LOGIC; --! synchronous reset
           low_high_tx : in  STD_LOGIC; --! the enable counter signal			  
           tbit : out  STD_LOGIC; --! pulse when time of one bit
           thalfbit : out STD_LOGIC); --! pulse when time of half bit
end basecounter;

architecture Behavioral of basecounter is
signal restart : std_logic;
signal count, ncount : unsigned(N-1 downto 0);
signal bytetbit, bytethalfbit: unsigned(N-1 downto 0);
begin
counter: process(resets,restart,count,low_high_tx)
begin
	if (resets='1')or(restart='1')then
		ncount<=(others=>'0');
	elsif (low_high_tx='1') then
		ncount<= count + 1 ;	
	else
		ncount<= count;
	end if;
end process counter;

bytetbit <=to_unsigned(Cycle_tbit,N);
bytethalfbit<=to_unsigned(Cycle_halfbit,N);
selector1: tbit<='1' when (count=bytetbit)  else '0';
selector2: thalfbit<='1' when (count=bytethalfbit)  else '0';
selector3: restart<='1' when (count=bytetbit)  else '0';

synch: process(clk,resetz)
begin
	if(resetz='0') then
		count <= (others=>'0');
	elsif RISING_EDGE(clk)then
		count<=ncount;
	end if;
end process synch;
end Behavioral;

