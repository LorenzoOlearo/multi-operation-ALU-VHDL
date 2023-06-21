library ieee;
use ieee.std_logic_1164.all;

entity test_SPI is
end test_SPI;

architecture test_SPI_arch of test is

  constant DATA_WIDTH : integer := 4;

  signal clk     : std_logic                                   := '0';
  signal rst     : std_logic                                   := '0';
  signal bit_in  : std_logic                                   := '0';
  signal bus_out : std_logic_vector((DATA_WIDTH*2)-1 downto 0) := (others => '0');
  signal flag    : std_logic                                   := '0';
  signal bus_in  : std_logic_vector((DATA_WIDTH*2)-1 downto 0) := "00001111";
  signal ready   : std_logic                                   := '0';


begin

  SPI : entity work.SPI
    generic map (
      DATA_WIDTH => DATA_WIDTH
      )
    port map (
      clk     => clk,
      rst     => rst,
      bit_in  => bit_in,
      ready   => ready,
      bus_out => bus_out
      );



  clock_generator : process is
  begin
    wait for 10 ns;
    clk <= not clk;
  end process;


  reset : process is
  begin
    rst <= '1';
    wait for 5 ns;
    rst <= '0';
    wait;
  end process;


  get_ready : process is
  begin
    wait for 10 ns;
    ready <= '1';
    wait for 170 ns;
    ready <= '0';
    wait;
  end process;


-- Times reference:
-- (N bits * 20 ns) + 20 ns [flip flop delay] + 10 ns [first bit delay]
-- 8 bits * 20 ns = 160 ns
-- 160 ns + 20 ns + 10 ns = 190 ns for the entire transmission
  create_input : process (clk, rst) is
    variable index : integer := 0;
  begin
    if rst = '1' then
      index := 0;
    elsif clk'event and clk = '1' then
      bit_in <= bus_in(index);
      index  := index + 1;
      if (index = DATA_WIDTH*2) then
        index := 0;
        flag  <= '1';
      end if;
    end if;
  end process;


end test_SPI_arch;
