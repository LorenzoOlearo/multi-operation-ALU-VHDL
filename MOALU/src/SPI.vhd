-- Todo:
--  enable
--  write bus on ready = '1'


library ieee;
use ieee.std_logic_1164.all;

entity SPI is
  generic(
    DATA_WIDTH : integer := 4
    );

  port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    bit_in  : in  std_logic;
    ready   : in  std_logic;
    bus_out : out std_logic_vector((DATA_WIDTH*2)-1 downto 0) := (others => '0')
    );

end SPI;


architecture SPI_arch of SPI is

  signal shift_register : std_logic_vector((DATA_WIDTH*2)-1 downto 0) := (others => '0');

begin

  shifter : process (clk, rst) is
  begin
    if (rst = '1') then
      shift_register <= (others => '0');
    elsif clk'event and clk = '1' then
      shift_register <= bit_in & shift_register(shift_register'high downto 1);
    end if;
  end process;


  bus_out <= shift_register when ready = '1' and rst = '0' else 
            (others => '0') when rst = '1';


end SPI_arch;
