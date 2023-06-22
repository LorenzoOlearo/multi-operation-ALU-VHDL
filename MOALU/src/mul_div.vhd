LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mul_div IS
  GENERIC(
    DATA_WIDTH : integer := 4
    );
  PORT(
    enable   : IN  std_logic;
    op       : IN  std_logic;
    x        : IN  unsigned(DATA_WIDTH-1 DOWNTO 0);
    y        : OUT unsigned(DATA_WIDTH-1 DOWNTO 0);
    overflow : OUT std_logic
    );
END mul_div;

ARCHITECTURE mul_div_arch OF mul_div IS
BEGIN

  overflow <= x(x'high) WHEN op = '0' AND enable = '1' ELSE
              x(0) WHEN op = '1' AND enable = '1' ELSE
              '0';
  y <= shift_left(x, 1) WHEN op = '0' AND enable = '1' ELSE
       shift_right(x, 1) WHEN op = '1' AND enable = '1' ELSE
       (OTHERS => '0');

END mul_div_arch;
