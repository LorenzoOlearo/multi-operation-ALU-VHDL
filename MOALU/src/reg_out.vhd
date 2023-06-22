LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY reg_out IS
  GENERIC(
    DATA_WIDTH : integer := 4
    );

  PORT(
    clk    : IN std_logic;
    rst    : IN std_logic;
    enable : IN std_logic;

    y1_in     : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    y2_in     : IN std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    result_in : IN std_logic_vector(2 DOWNTO 0);

    y1_out     : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    y2_out     : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    result_out : OUT std_logic_vector(2 DOWNTO 0)
    );
END ENTITY reg_out;


ARCHITECTURE reg_out_arch OF reg_out IS

BEGIN

  PROCESS(clk, rst) IS
  BEGIN
    IF rst = '1' THEN
      y1_out     <= (OTHERS => '0');
      y2_out     <= (OTHERS => '0');
      result_out <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
      IF enable = '1' THEN
        y1_out     <= y1_in;
        y2_out     <= y2_in;
        result_out <= result_in;
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE reg_out_arch;
