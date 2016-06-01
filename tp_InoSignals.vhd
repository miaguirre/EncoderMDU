--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:47:56 05/30/2016
-- Design Name:   
-- Module Name:   C:/Proyectos/Encoder/tp_InoSignals.vhd
-- Project Name:  Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Inp_signals
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tp_InoSignals IS
END tp_InoSignals;
 
ARCHITECTURE behavior OF tp_InoSignals IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Inp_signals
    PORT(
         clk : IN  std_logic;
         resetz : IN  std_logic;
         Enc_DH_R : IN  std_logic;
         Enc_DH_L : IN  std_logic;
         PB_Enc_DH_A : IN  std_logic;
         PB_Enc_DH_B : IN  std_logic;
         PB_Enc_DHMDA_A : IN  std_logic;
         PB_Enc_DHMDA_B : IN  std_logic;
         Enc_PC_R : IN  std_logic;
         Enc_PC_L : IN  std_logic;
         PB_Enc_PC_A : IN  std_logic;
         PB_Enc_PC_B : IN  std_logic;
         Sel0_Enc_PC : IN  std_logic;
         Sel1_Enc_PC : IN  std_logic;
         Sel2_Enc_PC : IN  std_logic;
         Error_CCFPGA : IN  std_logic;
         Error_TFPGA : IN  std_logic;
         Error_Pwr1 : IN  std_logic;
         Error_Pwr2 : IN  std_logic;
         Error_Pwr3 : IN  std_logic;
         message_normal : OUT  std_logic_vector(30 downto 0);
         message_error : OUT  std_logic_vector(30 downto 0);
         send : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal resetz : std_logic := '0';
   signal Enc_DH_R : std_logic := '0';
   signal Enc_DH_L : std_logic := '0';
   signal PB_Enc_DH_A : std_logic := '0';
   signal PB_Enc_DH_B : std_logic := '0';
   signal PB_Enc_DHMDA_A : std_logic := '0';
   signal PB_Enc_DHMDA_B : std_logic := '0';
   signal Enc_PC_R : std_logic := '0';
   signal Enc_PC_L : std_logic := '0';
   signal PB_Enc_PC_A : std_logic := '0';
   signal PB_Enc_PC_B : std_logic := '0';
   signal Sel0_Enc_PC : std_logic := '0';
   signal Sel1_Enc_PC : std_logic := '0';
   signal Sel2_Enc_PC : std_logic := '0';
   signal Error_CCFPGA : std_logic := '0';
   signal Error_TFPGA : std_logic := '0';
   signal Error_Pwr1 : std_logic := '0';
   signal Error_Pwr2 : std_logic := '0';
   signal Error_Pwr3 : std_logic := '0';

 	--Outputs
   signal message_normal : std_logic_vector(30 downto 0);
   signal message_error : std_logic_vector(30 downto 0);
   signal send : std_logic;

   -- Clock period definitions
   constant clk_period : time := 30.517578125 us;--! es la velocidad del oscilador
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Inp_signals PORT MAP (
          clk => clk,
          resetz => resetz,
          Enc_DH_R => Enc_DH_R,
          Enc_DH_L => Enc_DH_L,
          PB_Enc_DH_A => PB_Enc_DH_A,
          PB_Enc_DH_B => PB_Enc_DH_B,
          PB_Enc_DHMDA_A => PB_Enc_DHMDA_A,
          PB_Enc_DHMDA_B => PB_Enc_DHMDA_B,
          Enc_PC_R => Enc_PC_R,
          Enc_PC_L => Enc_PC_L,
          PB_Enc_PC_A => PB_Enc_PC_A,
          PB_Enc_PC_B => PB_Enc_PC_B,
          Sel0_Enc_PC => Sel0_Enc_PC,
          Sel1_Enc_PC => Sel1_Enc_PC,
          Sel2_Enc_PC => Sel2_Enc_PC,
          Error_CCFPGA => Error_CCFPGA,
          Error_TFPGA => Error_TFPGA,
          Error_Pwr1 => Error_Pwr1,
          Error_Pwr2 => Error_Pwr2,
          Error_Pwr3 => Error_Pwr3,
          message_normal => message_normal,
          message_error => message_error,
          send => send
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		resetz<='0';
      wait for clk_period*10;
		Enc_DH_R<='0';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='1';
      wait for clk_period*2;
		Enc_DH_R<='1';
		Enc_DH_L<='0';
      wait for clk_period*2;
		Enc_DH_R<='0';
		Enc_DH_L<='0';
      wait for clk_period*2;
		PB_Enc_DH_A <='1';
		PB_Enc_DH_B<='1';
      wait for clk_period*5;
		PB_Enc_DH_A <='1';
		PB_Enc_DH_B <='0';
      wait for clk_period*5;
		PB_Enc_DH_A <='0';
		PB_Enc_DH_B <='1';
      wait for clk_period*5;
		PB_Enc_DH_A <='0';
		PB_Enc_DH_B <='0';
      wait for clk_period*5;
		
      wait;
   end process;

END;
