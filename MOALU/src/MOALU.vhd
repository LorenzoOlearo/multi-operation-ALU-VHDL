LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY MOALU IS
  GENERIC(
    DATA_WIDTH : integer := 4
    );

  PORT(
    clk    : IN  std_logic;
    rst    : IN  std_logic;
    enable : IN  std_logic;
    bit_in : IN  std_logic;
    ready  : IN  std_logic;
    op     : IN  std_logic_vector(1 DOWNTO 0);
    y1     : OUT std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
    y2     : OUT std_logic_vector((DATA_WIDTH - 1) DOWNTO 0);
    result : OUT std_logic_vector(2 DOWNTO 0)
    );
END ENTITY MOALU;


ARCHITECTURE MOALU_arch OF MOALU IS

  SIGNAL spi_bus_out : std_logic_vector((DATA_WIDTH*2)-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL alu_enable  : std_logic;
  SIGNAL alu_op      : std_logic_vector(1 DOWNTO 0);
  SIGNAL alu_x1      : unsigned(DATA_WIDTH-1 DOWNTO 0)             := (OTHERS => '0');
  SIGNAL alu_x2      : unsigned(DATA_WIDTH-1 DOWNTO 0)             := (OTHERS => '0');
  SIGNAL alu_y1      : unsigned(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL alu_y2      : unsigned(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL alu_result  : std_logic_vector(2 DOWNTO 0);

  SIGNAL alu_master_enable : std_logic;

BEGIN

  alu_x1 <= unsigned(spi_bus_out(DATA_WIDTH-1 DOWNTO 0));
  alu_x2 <= unsigned(spi_bus_out((DATA_WIDTH*2)-1 DOWNTO DATA_WIDTH));

  alu_master_enable <= alu_enable AND enable;

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
      bus_out => spi_bus_out
      );


  FSM : ENTITY work.FSM
    PORT MAP(
      clk        => clk,
      rst        => rst,
      enable     => enable,
      ready      => ready,
      op         => op,
      alu_enable => alu_enable,
      alu_op     => alu_op
      );


  ALU : ENTITY work.ALU
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP (
      enable => alu_master_enable,
      op     => alu_op,
      x1     => alu_x1,
      x2     => alu_x2,
      y1     => alu_y1,
      y2     => alu_y2,
      result => alu_result
      );

  reg_out : ENTITY work.reg_out
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP (
      clk        => clk,
      rst        => rst,
      enable     => alu_master_enable,
      y1_in      => std_logic_vector(alu_y1),
      y2_in      => std_logic_vector(alu_y2),
      result_in  => alu_result,
      y1_out     => y1,
      y2_out     => y2,
      result_out => result
      );

END ARCHITECTURE MOALU_arch;
