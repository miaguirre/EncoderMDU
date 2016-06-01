----------------------------------------------------------------------------------
-- Company: Univaersidad de Sevilla
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    13:00:13 05/30/2016 
-- Design Name: 
-- Module Name:    Comparator_Enc - Behavioral 
-- Project Name: 
-- Target Devices:  Microsemi IGLOO2 FPGA 12K LE M2GL010T-1FGG484 
-- Tool versions: 
-- Description: Comparator for deciding the left or right spinning of the encoder
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Comparator_Enc is
	 Generic (NBits : integer := 5);
    Port ( Enc_Right : in  STD_LOGIC_VECTOR (NBits-1 downto 0);
           Enc_Left : in  STD_LOGIC_VECTOR (NBits-1 downto 0);
           Enc_Value : out  STD_LOGIC_VECTOR (NBits-1 downto 0);
           Enc_Spinning : out  STD_LOGIC);
end Comparator_Enc;

architecture Behavioral of Comparator_Enc is

begin
comp : process(Enc_Right, Enc_Left)
begin
	if (Enc_Right>=Enc_Left) then
		Enc_Value <= Enc_Right;
		Enc_Spinning <='0';
	else
		Enc_Value <= Enc_Left;		
		Enc_Spinning <='1';
	end if;
end process comp;
end Behavioral;

