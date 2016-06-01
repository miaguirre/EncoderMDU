----------------------------------------------------------------------------------
-- Company: Universidad de Sevilla
-- Engineer: M;iguel A. Aguirre
-- 
-- Create Date:    08:50:18 05/13/2016 
-- Design Name: 
-- Module Name:    fsm_encoder - Behavioral 
-- Project Name: 
-- Target Devices:  Microsemi IGLOO2 FPGA 12K LE M2GL010T-1FGG484 
-- Tool versions: 
-- Description: Finite State Machine for the detectioin or de roatation sense of the encoder
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

entity fsm_encoder is
    Port ( clk : in  STD_LOGIC; --!Clock
           resetz : in  STD_LOGIC; --!Reset signal, active low
           InA : in  STD_LOGIC; --!Encoder 0 signal A
           InB : in  STD_LOGIC; --!Encoder 0 signal B
           OutR : out STD_LOGIC; --!Right spinning
           OutL : out STD_LOGIC; --!Left spinning
			  Active : out STD_LOGIC --! Encoder is converting
			  );
end fsm_encoder;

architecture Behavioral of fsm_encoder is
type state is (idle, spinLA, spinRB, spinLAB, spinRAB, spinRA, spinLB, pulseL, pulseR);
signal cstate,pstate : state;
begin

dataL: OutL <= '1' when cstate = pulseL else '0';
dataR: OutR <= '1' when cstate = pulseR else '0';
activity: Active <='1' when ((cstate = spinLA) or (cstate =spinRB) or (cstate = spinLAB) 
    or (cstate = spinRAB) or (cstate = spinRA) or (cstate = spinLB)) else '0';
 

fsm: process (cstate, InA, InB)
begin
	case cstate is
		when Idle =>
             if (InA ='1') and (InB='0')then
                 pstate <= spinLA;
             elsif (InA ='0') and (InB='1')then
                 pstate <= spinRB;
            else
                 pstate <= Idle; 
             end if;
      when spinLA =>
            if (InA ='1') and (InB='1')then
                 pstate <= spinLAB;
            elsif (InA ='0') and (InB='0')then
				     pstate <= Idle;
            else					  
                 pstate <= spinLA;
            end if;
		when spinLAB =>
		      if (InA ='0') and (InB='1')then
                 pstate <= spinLB;
            elsif (InA ='0') and (InB='0')then
				     pstate <= Idle;
            elsif (InA ='1') and (InB='0')then
				     pstate <= spinLA;
            else					  
                 pstate <= spinLAB;
            end if;
      when spinLB =>
            if (InA ='0') and (InB='0')then
                 pstate <= pulseL;
            elsif (InA ='1') and (InB='1')then
				     pstate <= spinLAB;
            else					  
                 pstate <= spinLB;
            end if;
		when pulseL =>
				pstate <= Idle;
      when spinRB =>
            if (InA ='1') and (InB='1')then
                 pstate <= spinRAB;
            elsif (InA ='0') and (InB='0')then
				     pstate <= Idle;
            else					  
                 pstate <= spinRB;
            end if;
		when spinRAB =>
		      if (InA ='0') and (InB='1')then
                 pstate <= spinRB;
            elsif (InA ='0') and (InB='0')then
				     pstate <= Idle;
            elsif (InA ='1') and (InB='0')then
				     pstate <= spinRA;
            else					  
                 pstate <= spinRAB;
            end if;
      when spinRA =>
            if (InA ='0') and (InB='0')then
                 pstate <= pulseR;
            elsif (InA ='1') and (InB='1')then
				     pstate <= spinRAB;
            else					  
                 pstate <= spinRA;
            end if;
		when pulseR =>
				pstate <= Idle;
	end case;
end process fsm;


Sinc: process(clk,resetz)
begin
  if (resetz='0') then
       cstate<=idle;
  elsif RISING_EDGE(clk) then
       cstate<=pstate;
  end if;
end process sinc;

end Behavioral;

