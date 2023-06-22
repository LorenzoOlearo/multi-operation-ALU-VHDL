LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_reg_out IS
END ENTITY;

ARCHITECTURE test_reg_out_arch OF test_reg_out IS

  CONSTANT DATA_WIDTH : integer := 4;

  SIGNAL clk    : std_logic := '0';
  SIGNAL rst    : std_logic := '1';
  SIGNAL enable : std_logic := '0';

  SIGNAL y1_in     : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := "0000";
  SIGNAL y2_in     : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := "0000";
  SIGNAL result_in : std_logic_vector(2 DOWNTO 0)              := "000";

  SIGNAL y1_out     : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL y2_out     : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL result_out : std_logic_vector(2 DOWNTO 0)              := (OTHERS => '0');

BEGIN

  reg_out : ENTITY work.reg_out
    GENERIC MAP (
      DATA_WIDTH => 4
      )
    PORT MAP (
      clk        => clk,
      rst        => rst,
      enable     => enable,
      y1_in      => y1_in,
      y2_in      => y2_in,
      result_in  => result_in,
      y1_out     => y1_out,
      y2_out     => y2_out,
      result_out => result_out
      );


  clock_generator : PROCESS IS
  BEGIN
    WAIT FOR 10 ns;
    clk <= NOT clk;
  END PROCESS;


  test_case : PROCESS IS
  BEGIN
    WAIT FOR 2 ns;
    rst       <= '0';
    WAIT FOR 2 ns;
    rst       <= '1';
    enable    <= '1';
    y1_in     <= "1010";
    y2_in     <= "0101";
    result_in <= "001";
    WAIT FOR 50 ns;
    rst       <= '0';                   -- test reset
    WAIT FOR 2 ns;
    rst       <= '1';
    y1_in     <= "1010";
    y2_in     <= "0101";
    result_in <= "001";
    WAIT FOR 50 ns;
    enable    <= '0';                   -- test disable
    WAIT FOR 10 ns;
    y1_in     <= "0101";
    y2_in     <= "1010";
    result_in <= "010";
    WAIT FOR 50 ns;
    enable    <= '1';
    y1_in     <= "1010";
    y2_in     <= "0101";
    result_in <= "001";
    WAIT;
  END PROCESS;

END ARCHITECTURE;
