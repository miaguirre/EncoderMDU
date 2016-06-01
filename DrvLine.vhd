----------------------------------------------------------------------------------
-- Company: University of Sevilla
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    12:10:23 11/06/2014 
-- Design Name: Driver of ARINC429 lines
-- Module Name:    DrvLine - Behavioral 
-- Project Name: Transmitter ARINC429
-- Target Devices: Any
-- Tool versions: 
-- Description: this logic converts the natural output into differential logic ARINC429. Outopts are then registered
-- to synchonize the primary output and avoid race problems.
--
-- Dependencies: None
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

entity DrvLine is
    Port (
        clk : in STD_LOGIC; --! system clock
		  resetz : in STD_LOGIC; --! system asynchrnous reset, active low
        Bit_tx : in  STD_LOGIC; --! signal to transmit
		  Active : in  STD_LOGIC; -- ! when signal is ready to transmit, alse it has to be active high
        Line_p : out  STD_LOGIC; --! positive of differential signal
        Line_n : out  STD_LOGIC); --! negative of differential signal
end DrvLine;

architecture Behavioral of DrvLine is
signal iLine_p,iLine_n,iActive: STD_LOGIC;
begin
mgline: process (Bit_tx, iActive) --! combinational logic to manage the driver ARINC429
begin
	if(iActive='0') then
		iLine_p <='0';
		iLine_n <='0';
	else
		if (Bit_tx ='0') then
			iLine_n <='1';
			iLine_p <='0';
		else
			iLine_n <='0';
			iLine_p <='1';
		end if;	
	end if;
end process mgline;

sinc: process(resetz, clk) --! registering of outputs to fulfill the norms. 
begin
	if(resetz='0')then
		iActive<='0';
		Line_p<='0';
		Line_n<='0';
	elsif RISING_EDGE(clk) then
		iActive<=Active;
		Line_p <= iLine_p; 
		Line_n <= iLine_n;
	end if;
end process sinc;

end Behavioral;

