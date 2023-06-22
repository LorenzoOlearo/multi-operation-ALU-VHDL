LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_SPI IS
END test_SPI;

ARCHITECTURE test_SPI_arch OF test IS

  CONSTANT DATA_WIDTH : integer := 4;

  SIGNAL clk     : std_logic                                   := '0';
  SIGNAL rst     : std_logic                                   := '1';
  SIGNAL bit_in  : std_logic                                   := '0';
  SIGNAL bus_out : std_logic_vector((DATA_WIDTH*2)-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL flag    : std_logic                                   := '0';
  SIGNAL bus_in  : std_logic_vector((DATA_WIDTH*2)-1 DOWNTO 0) := "00001111";
  SIGNAL ready   : std_logic                                   := '0';
  SIGNAL enable  : std_logic                                   := '0';


BEGIN

  SPI : ENTITY work.SPI
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP (
      clk     => clk,
      rst     => rst,
      bit_in  => bit_in,
      ready   => ready,
      enable  => enable,
      bus_out => bus_out
      );



  clock_generator : PROCESS IS
  BEGIN
    WAIT FOR 10 ns;
    clk <= NOT clk;
  END PROCESS;


  reset : PROCESS IS
  BEGIN
    rst <= '0';
    WAIT FOR 5 ns;
    rst <= '1';
    WAIT;
  END PROCESS;


  get_ready : PROCESS IS
  BEGIN
    WAIT FOR 10 ns;
    ready  <= '1';
    enable <= '1';
    WAIT FOR 50 ns;
    enable <= '0';
    WAIT FOR 120 ns;
    ready  <= '0';
    WAIT;
  END PROCESS;


-- Times reference:
-- (N bits * 20 ns) + 20 ns [flip flop delay] + 10 ns [first bit delay]
-- 8 bits * 20 ns = 160 ns
-- 160 ns + 20 ns + 10 ns = 190 ns for the entire transmission
  create_input : PROCESS (clk, rst) IS
    VARIABLE index : integer := 0;
  BEGIN
    IF rst = '0' THEN
      index := 0;
    ELSIF clk'event AND clk = '1' THEN
      bit_in <= bus_in(index);
      index  := index + 1;
      IF (index = DATA_WIDTH*2) THEN
        index := 0;
        flag  <= '1';
      END IF;
    END IF;
  END PROCESS;


END test_SPI_arch;
