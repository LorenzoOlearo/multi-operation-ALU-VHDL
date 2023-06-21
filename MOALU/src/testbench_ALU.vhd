library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_test is
end ALU_test;

architecture ALU_test_arch of ALU_test is
  constant DATA_WIDTH : integer := 4;

  signal x1     : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
  signal x2     : unsigned(DATA_WIDTH-1 downto 0) := (others => '0');
  signal y1     : unsigned(DATA_WIDTH-1 downto 0);
  signal y2     : unsigned(DATA_WIDTH-1 downto 0);
  signal result : std_logic_vector(2 downto 0);
  signal op     : unsigned(1 downto 0)   := (others => '0');
  signal enable : std_logic              := '1';

begin

  ALU : entity work.ALU
    generic map (
      DATA_WIDTH => DATA_WIDTH
      )
    port map (
      enable => enable,
      op     => std_logic_vector(op),
      x1     => x1,
      x2     => x2,
      y1     => y1,
      y2     => y2,
      result => result
      );

  process
  begin
    wait for 5 ns * 3 * DATA_WIDTH * DATA_WIDTH;
    x1 <= x1 + 1;
  end process;

  process
  begin
    wait for 5 ns * 3;
    x2 <= x2 + 1;
  end process;

  process
  begin
    wait for 5 ns;
    if op = "10" then
      op <= "00";
    else
      op <= op + 1;
    end if;
  end process;

  process
  begin
    wait for 60 ns;
    enable <= '0';
    wait for 40 ns;
    enable <= '1';
  end process;

end ALU_test_arch;
