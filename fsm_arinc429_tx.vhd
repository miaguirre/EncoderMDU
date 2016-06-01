----------------------------------------------------------------------------------
-- Company: UNiversidad de Sevilla
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    10:57:44 11/14/2014 
-- Design Name: 
-- Module Name:    fsm_arinc429_tx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Finite State Machine for ARINC 429 transmission. In generates the necessary maneouvres to
--  generate the right temporization of signals that fullfils the norm. It is not dependant of the clock
--  frecuency.
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

entity fsm_arinc429_tx is
    Port ( clk : in  STD_LOGIC; --!system  clock
           resetz : in  STD_LOGIC; --!system asynchnous reset, active low
           start_trx : in  STD_LOGIC; --!signal that begins the whole transmission
           tbit : in  STD_LOGIC; --!time for complete bit
           thalfbit : in  STD_LOGIC; --!time for half bit
           countdword : in  STD_LOGIC; --! dword completed
           countfourbits : in  STD_LOGIC; --!four bits completed
			  wdtimer : in STD_LOGIC; --!freerunning watch dog timer for design protection
			  resets : out  STD_LOGIC; --! Synchronous reset, active high, keeps the transmitter frozen
           ena_basecounter : out  STD_LOGIC; --! enables base bit counter
           ena_bitcounter : out  STD_LOGIC; --! enables  dword counter
--			  load_dword : out  STD_LOGIC; --! load the message from register
			  shift_dword : out  STD_LOGIC;  --! shifts the dword to the LSB
           active_bit : out  STD_LOGIC); --! signal that give permission for a transmisssion. It is active high
end fsm_arinc429_tx;

architecture Behavioral of fsm_arinc429_tx is

type state is (idle1, thalfbiton, thalbitoff ,nextbit,shiftmessage, waitfourbits, fouridlebits, error,
						error_waitfourbits,error_fouridlebits);
signal currentst, nextst : state;

begin
synchronous_reset: resets <='1' when currentst=idle1 or currentst=error else '0'; 
new_bit_t_send:    shift_dword<='1' when currentst=shiftmessage else '0'; --! next bit of the message
put_active:        active_bit<='1' when currentst=thalfbiton else '0'; --! activate the line with bit contents
--load_message_reg:  load_dword<='1' when currentst=tr_dword else '0';


trx_fsm: process(currentst, start_trx, tbit, thalfbit, countdword, countfourbits,wdtimer)
begin
		case currentst is
			when idle1 => --! Idle state
				ena_basecounter<='0';
				ena_bitcounter<='0';
				if (start_trx='1') then
					nextst<=thalfbiton;
				else
					nextst<=idle1;
				end if;
			when thalfbiton => --! state that during the transmission half bit period is on. Bit is sent.
				ena_basecounter<='1';
				ena_bitcounter<='0';
				if(wdtimer='1')then --!enables watch dog timer
					nextst<=error;
				elsif(thalfbit='1') then --wait for half bit
					nextst<=thalbitoff; 
				else
					nextst<=thalfbiton;
				end if;				
			when thalbitoff => --! state that during the transmission half bit period is off
				ena_basecounter<='1';
				ena_bitcounter<='0';
				if(wdtimer='1')then --!enables watch dog timer
					nextst<=error;
				elsif(tbit='1') then  --!bit is transmitted
					nextst<=nextbit; 
				else
					nextst<=thalbitoff;
				end if;	
			when nextbit => --! state to increment the bits counter 
				ena_basecounter<='1';
				ena_bitcounter<='1';
				if(wdtimer='1')then
					nextst<=error;
				elsif(countdword='1') then  --wait for half bit
					nextst<=waitfourbits; 
				else	
					nextst<=shiftmessage;
				end if;
			when shiftmessage => --! state to shift the message and send other bit
				ena_basecounter<='0';
				ena_bitcounter<='0';
				if(wdtimer='1')then 
					nextst<=error;
				else
					nextst<=thalfbiton; 
				end if;
			when waitfourbits => --! state of waiting
				ena_basecounter<='1';
				ena_bitcounter<='0';
				if(wdtimer='1')then
					nextst<=error;
				elsif(tbit='1') then  --wait for total bit
					nextst<=fouridlebits; 
				else	
					nextst<=waitfourbits;
				end if;
			when fouridlebits =>
				ena_basecounter<='1';
				ena_bitcounter<='1';
				if(wdtimer='1')then
					nextst<=error;
				elsif(countfourbits='1') then 
					nextst<=idle1;
				else	
					nextst<=waitfourbits; 
				end if;	
			when error => --! error detected in the transmission time
				ena_basecounter<='0';
				ena_bitcounter<='0';
				nextst<=error_waitfourbits; 
			when error_waitfourbits => --! error detected at bit level
				ena_basecounter<='1';
				ena_bitcounter<='0';
				if(tbit='1') then  
					nextst<=error_fouridlebits; 
				else	
					nextst<=error_waitfourbits;
				end if;
			when error_fouridlebits => --! error detected in message
				ena_basecounter<='1';
				ena_bitcounter<='1';
				if(countfourbits='1') then 
					nextst<=idle1;
				else	
					nextst<=error_waitfourbits; 
				end if;
			when others =>
				ena_basecounter<='0';
				ena_bitcounter<='0';
				nextst<=error; 					
		end case;
end process trx_fsm;

synch: process (resetz,clk)
begin
	if(resetz='0')then
		currentst<=idle1;
	elsif RISING_EDGE(clk) then         
	   currentst<=nextst;
	end if;
end process synch;
		
end Behavioral;

