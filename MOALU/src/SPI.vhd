LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SPI IS
  GENERIC(
    DATA_WIDTH : integer := 4
    );

  PORT(
    clk     : IN  std_logic;
    rst     : IN  std_logic;
    bit_in  : IN  std_logic;
    ready   : IN  std_logic;
    enable  : IN  std_logic;
    bus_out : OUT std_logic_vector((DATA_WIDTH*2)-1 DOWNTO 0) := (OTHERS => '0')
    );

END SPI;


ARCHITECTURE SPI_arch OF SPI IS

  SIGNAL shift_register : std_logic_vector((DATA_WIDTH*2)-1 DOWNTO 0) := (OTHERS => '0');

BEGIN

  shifter : PROCESS (clk, rst) IS
  BEGIN
    IF (rst = '0') THEN
      shift_register <= (OTHERS => '1');
    ELSIF clk'event AND clk = '1' THEN
      IF enable = '1' THEN
        shift_register <= bit_in & shift_register(shift_register'high DOWNTO 1);
      END IF;
    END IF;
  END PROCESS;


  bus_out <= shift_register WHEN ready = '1' AND rst = '1' AND clk'event AND clk ='1' ELSE
             (OTHERS => '1') WHEN rst = '0';


END SPI_arch;
