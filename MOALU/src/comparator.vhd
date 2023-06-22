LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY comparator IS
  GENERIC(
    DATA_WIDTH : integer := 4
    );
  PORT(
    a      : IN  unsigned(DATA_WIDTH-1 DOWNTO 0);
    b      : IN  unsigned(DATA_WIDTH-1 DOWNTO 0);
    result : OUT std_logic_vector(2 DOWNTO 0)
    );
END comparator;

ARCHITECTURE comparator_arch OF comparator IS
BEGIN

  result(0) <= '1' WHEN a < b ELSE '0';
  result(1) <= '1' WHEN a = b ELSE '0';
  result(2) <= '1' WHEN a > b ELSE '0';

END comparator_arch;
