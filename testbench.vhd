LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Global.ALL;

ENTITY testbench IS
	GENERIC 
	(
		N : NATURAL := 8
	);
END testbench;

ARCHITECTURE tb OF testbench IS

	-- DUT component
	COMPONENT alarm IS
		PORT 
		(
			sensors : IN std_logic_vector(0 TO N - 1);
			key     : IN std_logic;
			clock   : IN std_logic;
			siren   : OUT std_logic
		);
	END COMPONENT;

	CONSTANT num_cycles : INTEGER := 400;

	SIGNAL clock        : std_logic := '0';
	SIGNAL sensors      : std_logic_vector(0 TO N - 1) := "00000000";
	SIGNAL key          : std_logic := '0';
	SIGNAL siren        : std_logic := '0';

BEGIN
	-- Connect DUT
	DUT : alarm
	PORT MAP(sensors, key, clock, siren);

	-- Generate Clock
	clk : PROCESS
	BEGIN
		FOR i IN 1 TO num_cycles LOOP
			clock <= NOT clock;
			WAIT FOR 500 ns;
			clock <= NOT clock;
			WAIT FOR 500 ns;
		END LOOP;
		WAIT;
	END PROCESS;

	-- Tests
	tests : PROCESS
	BEGIN
		key     <= '1';
		sensors <= "00001100";
		WAIT FOR 100 us;
 
		ASSERT(siren = '1') REPORT "Sirens did NOT trigger AFTER sensor activation" SEVERITY failure;
 
		WAIT;
	END PROCESS;
 
END tb;