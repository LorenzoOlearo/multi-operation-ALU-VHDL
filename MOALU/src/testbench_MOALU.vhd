library ieee;

use ieee.std_logic_1164.all;


entity MOALU_test is
end entity;

architecture MOALU_test_arch of MOALU_test is
  constant DATA_WIDTH : integer := 4;
  constant X1 : std_logic_vector(DATA_WIDTH-1 downto 0) := "1010";
  constant X2 : std_logic_vector(DATA_WIDTH-1 downto 0) := "1100";

  signal clk : std_logic;
  signal rst : std_logic := '0';
  signal enable : std_logic := '1';
  signal bit_in : std_logic;
  signal ready : std_logic := '0';
  signal op : std_logic_vector(1 downto 0) := "00";
  signal y1 : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal y2 : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal result : std_logic_vector(2 downto 0);

  signal bus_in : std_logic_vector(DATA_WIDTH*2-1 downto 0);
begin

  bus_in <= X2 & X1;

  MOALU: entity work.MOALU
    generic map (
      DATA_WIDTH => DATA_WIDTH
      )
    port map (
      clk => clk,
      rst => rst,
      enable => enable,
      bit_in => bit_in,
      ready => ready,
      op => op,
      y1 => y1,
      y2 => y2,
      result => result
      );

  clock_generator: process is
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
  end process;

  create_input : process (clk) is
    variable index : integer := 0;
  begin
    if clk'event and clk = '1' then
      if index = 0 then
        rst <= '0';
      end if;
      if (index < DATA_WIDTH*2)	then
        bit_in <= bus_in(index);
      end if;
      index  := index + 1;
      if (index = DATA_WIDTH*2 + 1) then
        ready <= '1';
      end if;
      if (index = DATA_WIDTH*2 + 2) then
        ready <= '0';
      end if;
      if (index = DATA_WIDTH*2 + 5) then
        rst <= '1';
        index := 0;
        case op is
          when "00" => op <= "01";
          when "01" => op <= "10";
          when others => op <= "00";
        end case;
      end if;
    end if;
  end process;
end MOALU_test_arch;