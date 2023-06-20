library ieee;
use ieee.std_logic_1164.all;

entity test_reg_out is
end entity;

architecture test_reg_out_arch of test_reg_out is

  constant DATA_WIDTH : integer := 4;

  signal clk    : std_logic := '0';
  signal rst    : std_logic := '0';
  signal enable : std_logic := '0';

  signal y1_in   : std_logic_vector(DATA_WIDTH - 1 downto 0) := "0000";
  signal y2_in   : std_logic_vector(DATA_WIDTH - 1 downto 0) := "0000";
  signal comp_in : std_logic_vector(2 downto 0)              := "000";

  signal y1_out   : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal y2_out   : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
  signal comp_out : std_logic_vector(2 downto 0)              := (others => '0');

begin

  reg_out : entity work.reg_out
    generic map (
      DATA_WIDTH => 4
      )
    port map (
      clk      => clk,
      rst      => rst,
      enable   => enable,
      y1_in    => y1_in,
      y2_in    => y2_in,
      comp_in  => comp_in,
      y1_out   => y1_out,
      y2_out   => y2_out,
      comp_out => comp_out
      );


  clock_generator : process is
  begin
    wait for 10 ns;
    clk <= not clk;
  end process;


  test_case : process is
  begin
    wait for 2 ns;
    rst     <= '1';
    wait for 2 ns;
    rst     <= '0';
    enable  <= '1';
    y1_in   <= "1010";
    y2_in   <= "0101";
    comp_in <= "001";
    wait for 50 ns;
    rst     <= '1';     -- test reset
    wait for 2 ns;
    rst     <= '0';
    y1_in   <= "1010";
    y2_in   <= "0101";
    comp_in <= "001";
    wait for 50 ns;
    enable  <= '0';     -- test disable
    wait for 10 ns;
    y1_in   <= "0101";
    y2_in   <= "1010";
    comp_in <= "010";
    wait for 50 ns;
    enable  <= '1';
    y1_in   <= "1010";
    y2_in   <= "0101";
    comp_in <= "001";
    wait;
  end process;

end architecture;
