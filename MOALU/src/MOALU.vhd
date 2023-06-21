library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MOALU is
  generic(
    DATA_WIDTH : integer := 4
    );

  port(
    clk    : in  std_logic;
    rst    : in  std_logic;
    enable : in  std_logic;
    bit_in : in  std_logic;
    ready  : in  std_logic;
    op     : in  std_logic_vector(1 downto 0);
    y1     : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    y2     : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    result : out std_logic_vector(2 downto 0)
    );
end entity MOALU;


architecture MOALU_arch of MOALU is

  signal spi_bus_out : std_logic_vector((DATA_WIDTH*2)-1 downto 0) := (others => '0');
  signal alu_enable  : std_logic;
  signal alu_op      : std_logic_vector(1 downto 0);
  signal alu_x1      : unsigned(DATA_WIDTH-1 downto 0)                      := (others => '0');
  signal alu_x2      : unsigned(DATA_WIDTH-1 downto 0)                      := (others => '0');
  signal alu_y1      : unsigned(DATA_WIDTH-1 downto 0);
  signal alu_y2      : unsigned(DATA_WIDTH-1 downto 0);
  signal alu_result  : std_logic_vector(2 downto 0);

  signal alu_master_enable : std_logic;

begin

  alu_x1 <= unsigned(spi_bus_out(DATA_WIDTH-1 downto 0));
  alu_x2 <= unsigned(spi_bus_out((DATA_WIDTH*2)-1 downto DATA_WIDTH));

  alu_master_enable <= alu_enable and enable;

  SPI : entity work.SPI
    generic map (
      DATA_WIDTH => DATA_WIDTH
      )
    port map (
      clk     => clk,
      rst     => rst,
      bit_in  => bit_in,
      ready   => ready,
      bus_out => spi_bus_out
      );


  FSM : entity work.FSM
    port map(
      clk        => clk,
      rst        => rst,
      enable     => enable,
      ready      => ready,
      op         => op,
      alu_enable => alu_enable,
      alu_op     => alu_op
      );


  ALU : entity work.ALU
    generic map (
      DATA_WIDTH => DATA_WIDTH
      )
    port map (
      enable => alu_master_enable,
      op     => alu_op,
      x1     => alu_x1,
      x2     => alu_x2,
      y1     => alu_y1,
      y2     => alu_y2,
      result => alu_result
      );

  reg_out : entity work.reg_out
    generic map (
      DATA_WIDTH => DATA_WIDTH
      )
    port map (
      clk       => clk,
      rst       => rst,
      enable    => alu_enable,
      y1_in     => std_logic_vector(alu_y1),
      y2_in     => std_logic_vector(alu_y2),
      result_in => alu_result,
      y1_out    => y1,
      y2_out    => y2,
      result_out  => result
      );

end architecture MOALU_arch;
