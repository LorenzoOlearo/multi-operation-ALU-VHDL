library ieee;

use ieee.std_logic_1164.all;

entity test_FSM is
end test_FSM;

architecture test_FSM_arch of test_FSM is
  signal clk        : std_logic                    := '0';
  signal rst        : std_logic                    := '0';
  signal enable     : std_logic                    := '1';
  signal fsm_input  : std_logic_vector(2 downto 0) := "000";
  signal fsm_output : std_logic_vector(2 downto 0);
begin

  clock_generator : process is
  begin
    wait for 5 ns;
    clk <= not clk;
  end process;

  process(clk) is
    variable count : integer := 0;
  begin
    if(clk'event and clk = '1') then
      if (count = 1) then
        fsm_input <= "100";
      elsif (count = 2) then
        fsm_input <= "000";
      elsif (count = 3) then
        fsm_input <= "001";
      elsif (count = 5) then
        fsm_input <= "110";
      elsif (count = 7) then
        fsm_input <= "000";
      elsif (count = 10) then
        fsm_input <= "011";
      elsif (count = 11) then
        fsm_input <= "000";
      elsif (count = 12) then
        fsm_input <= "100";
      elsif (count = 13) then
        fsm_input <= "000";
      end if;
      count := count + 1;
    end if;
  end process;

  FSM : entity work.FSM
    port map(
      clk        => clk,
      rst        => rst,
      enable     => enable,
      ready      => fsm_input(2),
      op         => fsm_input(1 downto 0),
      alu_enable => fsm_output(2),
      alu_op     => fsm_output(1 downto 0)
      );

end test_FSM_arch;
