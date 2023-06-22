LIBRARY ieee;

USE ieee.std_logic_1164.ALL;

ENTITY test_FSM IS
END test_FSM;

ARCHITECTURE test_FSM_arch OF test_FSM IS
  SIGNAL clk        : std_logic                    := '0';
  SIGNAL rst        : std_logic                    := '0';
  SIGNAL enable     : std_logic                    := '1';
  SIGNAL fsm_input  : std_logic_vector(2 DOWNTO 0) := "000";
  SIGNAL fsm_output : std_logic_vector(2 DOWNTO 0);
BEGIN

  clock_generator : PROCESS IS
  BEGIN
    WAIT FOR 5 ns;
    clk <= NOT clk;
  END PROCESS;

  PROCESS(clk) IS
    VARIABLE count : integer := 0;
  BEGIN
    IF(clk'event AND clk = '1') THEN
      IF (count = 1) THEN
        fsm_input <= "100";
      ELSIF (count = 2) THEN
        fsm_input <= "000";
      ELSIF (count = 3) THEN
        fsm_input <= "001";
      ELSIF (count = 5) THEN
        fsm_input <= "110";
      ELSIF (count = 7) THEN
        fsm_input <= "000";
      ELSIF (count = 10) THEN
        fsm_input <= "011";
      ELSIF (count = 11) THEN
        fsm_input <= "000";
      ELSIF (count = 12) THEN
        fsm_input <= "100";
      ELSIF (count = 13) THEN
        fsm_input <= "000";
      END IF;
      count := count + 1;
    END IF;
  END PROCESS;

  FSM : ENTITY work.FSM
    PORT MAP(
      clk        => clk,
      rst        => rst,
      enable     => enable,
      ready      => fsm_input(2),
      op         => fsm_input(1 DOWNTO 0),
      alu_enable => fsm_output(2),
      alu_op     => fsm_output(1 DOWNTO 0)
      );

END test_FSM_arch;
