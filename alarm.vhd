LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE Global IS

	TYPE alarm_state_type IS (OFF, ARMING, ARMED, TRIGGERING, TRIGGERED);

END PACKAGE Global;

PACKAGE BODY Global IS
END PACKAGE BODY Global;

-----------
-- TIMER --
-----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY timer IS
	PORT 
	(
		clock     : IN std_logic;
		run       : IN std_logic;
		triggered : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavioral OF timer IS
BEGIN
	PROCESS
	VARIABLE v_count : NATURAL := 0;
	BEGIN
		triggered <= '0';
		LOOP
		LOOP
		WAIT UNTIL clock = '1' OR run = '0';
		EXIT WHEN run = '0';
		v_count := v_count + 1;
		IF v_count > 30 THEN
			triggered <= '1';
		ELSE
			triggered <= '0';
		END IF;
	END LOOP;
	v_count := 0;
	triggered <= '0';
	END LOOP;
END PROCESS;

END ARCHITECTURE;

---------------
-- ALARM FSM --
---------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Global.ALL;

ENTITY alarm_state IS
	GENERIC 
	(
		N : NATURAL := 8
	);
	PORT 
	(
		sensors : IN std_logic_vector(0 TO N - 1);
		key     : IN std_logic;
		clock   : IN std_logic;
		state   : OUT alarm_state_type
	);
END ENTITY;

ARCHITECTURE behavioral OF alarm_state IS

	SIGNAL current_state, next_state : alarm_state_type := OFF;
	SIGNAL temp_siren                : std_logic := '0';
	SIGNAL timer_enabled             : std_logic := '0';
	SIGNAL timed                     : std_logic := '0';
	SIGNAL sensed                    : std_logic := '0';

BEGIN
	timer : ENTITY work.timer(behavioral)
		PORT MAP(clock, timer_enabled, timed);

		PROCESS (sensors)
	BEGIN
		sensed <= '0';
		FOR i IN sensors'RANGE LOOP
			--report "Sensor " & integer'image(i) & "=" & std_logic'image(sensors(i));
			IF sensors(i) /= '0' THEN
				sensed <= '1';
			END IF;
		END LOOP;
	END PROCESS;

	PROCESS (clock)
		BEGIN
			IF (clock'EVENT AND clock = '1') THEN
				--report "STATE CHANGE: " & integer'image(alarm_state_type'POS(current_state)) & " to " & integer'image(alarm_state_type'POS(next_state)) & "SENSED=" & std_logic'image(sensed);
				current_state <= next_state;
				state         <= next_state;
			END IF;
		END PROCESS;

		PROCESS (current_state, sensed, key, sensors, timed)
			BEGIN
				CASE current_state IS
					WHEN OFF => 
						IF key = '0' THEN
							next_state <= OFF;
						ELSE
							next_state <= ARMING;
						END IF;
						timer_enabled <= '0';
					WHEN ARMING => 
						IF key = '0' THEN
							next_state <= OFF;
						ELSIF timed = '1' THEN
							next_state <= ARMED;
						END IF;
						timer_enabled <= '1';
					WHEN ARMED => 
						IF key = '0' THEN
							next_state <= OFF;
						ELSIF sensed = '0' THEN
							next_state <= ARMED;
						ELSIF sensed = '1' THEN
							next_state <= TRIGGERING;
						END IF;
						timer_enabled <= '0';
					WHEN TRIGGERING => 
						IF key = '0' THEN
							next_state <= OFF;
						ELSIF timed = '1' THEN
							next_state <= TRIGGERED;
						END IF;
						timer_enabled <= '1';
					WHEN TRIGGERED => 
						IF key = '0' THEN
							next_state <= OFF;
						ELSE
							next_state <= TRIGGERED;
						END IF;
				END CASE;
			END PROCESS;

END ARCHITECTURE;

-----------
-- ALARM --
-----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Global.ALL;

ENTITY alarm IS
	GENERIC 
	(
		N : NATURAL := 8
	);
	PORT 
	(
		sensors : IN std_logic_vector(0 TO N - 1);
		key     : IN std_logic;
		clock   : IN std_logic;
		siren   : OUT std_logic
	);
END ENTITY;

ARCHITECTURE behavioral OF alarm IS
	SIGNAL state : alarm_state_type;
BEGIN
	timer : ENTITY work.alarm_state(behavioral)
			GENERIC MAP(N => N)
		PORT MAP(sensors, key, clock, state);

		PROCESS (state)
	BEGIN
		IF state = TRIGGERED THEN
			siren <= '1';
		ELSE
			siren <= '0';
		END IF;
	END PROCESS;
END ARCHITECTURE;