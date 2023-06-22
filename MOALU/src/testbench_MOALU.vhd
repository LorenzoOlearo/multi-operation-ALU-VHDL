LIBRARY ieee;

USE ieee.std_logic_1164.ALL;


ENTITY MOALU_test IS
END ENTITY;

ARCHITECTURE MOALU_test_arch OF MOALU_test IS
  CONSTANT DATA_WIDTH : integer                                 := 4;
  CONSTANT X1         : std_logic_vector(DATA_WIDTH-1 DOWNTO 0) := "1010";
  CONSTANT X2         : std_logic_vector(DATA_WIDTH-1 DOWNTO 0) := "1100";

  SIGNAL clk    : std_logic;
  SIGNAL rst    : std_logic                    := '0';
  SIGNAL enable : std_logic                    := '1';
  SIGNAL bit_in : std_logic;
  SIGNAL ready  : std_logic                    := '0';
  SIGNAL op     : std_logic_vector(1 DOWNTO 0) := "00";
  SIGNAL y1     : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL y2     : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL result : std_logic_vector(2 DOWNTO 0);

  SIGNAL bus_in : std_logic_vector(DATA_WIDTH*2-1 DOWNTO 0);
BEGIN

  bus_in <= X2 & X1;

  MOALU : ENTITY work.MOALU
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP (
      clk    => clk,
      rst    => rst,
      enable => enable,
      bit_in => bit_in,
      ready  => ready,
      op     => op,
      y1     => y1,
      y2     => y2,
      result => result
      );

  clock_generator : PROCESS IS
  BEGIN
    clk <= '0';
    WAIT FOR 5 ns;
    clk <= '1';
    WAIT FOR 5 ns;
  END PROCESS;

  create_input : PROCESS (clk) IS
    VARIABLE index : integer := 0;
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF index = 0 THEN
        rst <= '0';
      END IF;
      IF (index < DATA_WIDTH*2) THEN
        bit_in <= bus_in(index);
      END IF;
      index := index + 1;
      IF (index = DATA_WIDTH*2 + 1) THEN
        ready <= '1';
      END IF;
      IF (index = DATA_WIDTH*2 + 2) THEN
        ready <= '0';
      END IF;
      IF (index = DATA_WIDTH*2 + 5) THEN
        rst   <= '1';
        index := 0;
        CASE op IS
          WHEN "00"   => op <= "01";
          WHEN "01"   => op <= "10";
          WHEN OTHERS => op <= "00";
        END CASE;
      END IF;
    END IF;
  END PROCESS;
END MOALU_test_arch;
