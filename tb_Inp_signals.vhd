-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT Inp_signals
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC;
           Enc0p : in  STD_LOGIC;
           Enc0n : in  STD_LOGIC;
           Enc1p : in  STD_LOGIC;
           Enc1n : in  STD_LOGIC;
           SigA : in  STD_LOGIC;
           SigB : in  STD_LOGIC;
           SigC : in  STD_LOGIC;
           message : out  STD_LOGIC_VECTOR (31 downto 0);
           send : out  STD_LOGIC);
          END COMPONENT;

          SIGNAL clk:  std_logic:='0';
          SIGNAL resetz:  std_logic :='1';
          SIGNAL Enc0p, Enc0n, Enc1p, Enc1n:  std_logic;
          SIGNAL SigA, SigB, SigC:  std_logic;
          SIGNAL Send:  std_logic;
          SIGNAL message :  std_logic_vector(31 downto 0);
          

  BEGIN

  -- Component Instantiation
          uut: Inp_signals PORT MAP(
			   clk => clk,
				resetz => resetz,
				Enc0p => Enc0p,
				Enc0n => Enc0n,
				Enc1p => Enc1p,
				Enc1n => Enc1n,
				SigA => SigA,
				SigB => SigB,
				SigC => SigC,
				message => message,
				send => send
          );
clock : process
begin
	clk <= not clk;
	wait for 5ns;
end process;

resetz<='0', '1' after 120ns;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN
		  Enc0p <='0';
		  Enc0n <='0';
		  Enc1p <='0';
		  Enc1n <='0';
		  SigA <= '0';
		  SigB <= '0';
		  SigC <= '0';
        wait for 400 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  SigA <= '1'; --
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  SigA <= '0'; --
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  SigA <= '1';
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';        
		  wait for 200 ns; -- wait until global set/reset completes
		  SigA <= '0';
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';       
		  wait for 200 ns; -- wait until global set/reset completes
		  SigA <= '1';
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';
		  wait for 200 ns; -- wait until global set/reset completes
		  SigB <= '1';
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  SigB <= '0';
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';        -- Add user defined stimulus here
		  Enc0p <='0';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='1';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='1';
		  Enc0n <='0';
        wait for 200 ns; -- wait until global set/reset completes
		  Enc0p <='0';
		  Enc0n <='0';        -- Add user defined stimulus here


        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
