library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity twoDivMul is
  generic(
    DATA_WIDTH : integer := 4
    );
  port(
    enable : in std_logic;
    op : in std_logic;
    x : in unsigned(DATA_WIDTH-1 downto 0);
    y : out unsigned(DATA_WIDTH-1 downto 0);
    overflow : out std_logic
    );
end twoDivMul;

architecture twoDivMul_arch of twoDivMul is
begin

  overflow <= x(x'high) when op = '0' and enable = '1' else
              x(0)      when op = '1' and enable = '1' else
              '0';
  y <= shift_left(x, 1)  when op = '0' and enable = '1' else
       shift_right(x, 1) when op = '1' and enable = '1' else
       (others => '0');

end twoDivMul_arch;