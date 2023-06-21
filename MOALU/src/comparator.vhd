library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
  generic(
    DATA_WIDTH : integer := 4
    );
  port(
    a : in unsigned(DATA_WIDTH-1 downto 0);
    b : in unsigned(DATA_WIDTH-1 downto 0);
    result : out std_logic_vector(2 downto 0)
    );
end comparator;

architecture comparator_arch of comparator is
begin

  result(0) <= '1' when a < b else '0';
  result(1) <= '1' when a = b else '0';
  result(2) <= '1' when a > b else '0';

end comparator_arch;
