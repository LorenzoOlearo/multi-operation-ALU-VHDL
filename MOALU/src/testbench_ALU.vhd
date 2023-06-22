LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU_test IS
END ALU_test;

ARCHITECTURE ALU_test_arch OF ALU_test IS
  CONSTANT DATA_WIDTH : integer := 4;

  SIGNAL x1     : unsigned(DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL x2     : unsigned(DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL y1     : unsigned(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL y2     : unsigned(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL result : std_logic_vector(2 DOWNTO 0);
  SIGNAL op     : unsigned(1 DOWNTO 0)            := (OTHERS => '0');
  SIGNAL enable : std_logic                       := '1';

BEGIN

  ALU : ENTITY work.ALU
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP (
      enable => enable,
      op     => std_logic_vector(op),
      x1     => x1,
      x2     => x2,
      y1     => y1,
      y2     => y2,
      result => result
      );

  PROCESS
  BEGIN
    WAIT FOR 5 ns * 3 * DATA_WIDTH * DATA_WIDTH;
    x1 <= x1 + 1;
  END PROCESS;

  PROCESS
  BEGIN
    WAIT FOR 5 ns * 3;
    x2 <= x2 + 1;
  END PROCESS;

  PROCESS
  BEGIN
    WAIT FOR 5 ns;
    IF op = "10" THEN
      op <= "00";
    ELSE
      op <= op + 1;
    END IF;
  END PROCESS;

  PROCESS
  BEGIN
    WAIT FOR 60 ns;
    enable <= '0';
    WAIT FOR 40 ns;
    enable <= '1';
  END PROCESS;

END ALU_test_arch;
