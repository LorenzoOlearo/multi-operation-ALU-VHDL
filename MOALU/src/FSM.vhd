LIBRARY ieee;

USE ieee.std_logic_1164.ALL;

ENTITY FSM IS
  PORT(
    clk        : IN  std_logic;
    rst        : IN  std_logic;
    enable     : IN  std_logic;
    ready      : IN  std_logic;
    op         : IN  std_logic_vector(1 DOWNTO 0);
    alu_enable : OUT std_logic;
    alu_op     : OUT std_logic_vector(1 DOWNTO 0)
    );
END FSM;

ARCHITECTURE FSM_arch OF FSM IS
  TYPE state_type IS (reset, mul, div, com, mul_h, div_h, com_h, err);
  SIGNAL state      : state_type := reset;
  SIGNAL next_state : state_type;
  SIGNAL o          : std_logic_vector(2 DOWNTO 0);
  SIGNAL i          : std_logic_vector(2 DOWNTO 0);
BEGIN

  i          <= ready & op;
  alu_enable <= o(2);
  alu_op     <= o(1 DOWNTO 0);

  -- set state
  PROCESS(clk, rst) IS
  BEGIN
    IF rst = '0' THEN
      state <= reset;
    ELSIF (clk'event AND clk = '1' AND enable = '1') THEN
      state <= next_state;
    END IF;
  END PROCESS;

  -- next state function
  PROCESS(i, state) IS
  BEGIN
    CASE state IS

      WHEN reset =>
        CASE i IS
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN "111" =>
            next_state <= err;
          WHEN OTHERS =>
            next_state <= reset;
        END CASE;

      WHEN mul =>
        CASE i IS
          WHEN "000" =>
            next_state <= mul_h;
          WHEN "001" =>
            next_state <= div;
          WHEN "010" =>
            next_state <= com;
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN div =>
        CASE i IS
          WHEN "000" =>
            next_state <= mul;
          WHEN "001" =>
            next_state <= div_h;
          WHEN "010" =>
            next_state <= com;
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN com =>
        CASE i IS
          WHEN "000" =>
            next_state <= mul;
          WHEN "001" =>
            next_state <= div;
          WHEN "010" =>
            next_state <= com_h;
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN mul_h =>
        CASE i IS
          WHEN "000" =>
            next_state <= mul_h;
          WHEN "001" =>
            next_state <= div;
          WHEN "010" =>
            next_state <= com;
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN div_h =>
        CASE i IS
          WHEN "000" =>
            next_state <= mul;
          WHEN "001" =>
            next_state <= div_h;
          WHEN "010" =>
            next_state <= com;
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN com_h =>
        CASE i IS
          WHEN "000" =>
            next_state <= mul;
          WHEN "001" =>
            next_state <= div;
          WHEN "010" =>
            next_state <= com_h;
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN err =>
        CASE i IS
          WHEN "100" =>
            next_state <= mul;
          WHEN "101" =>
            next_state <= div;
          WHEN "110" =>
            next_state <= com;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

    END CASE;
  END PROCESS;

  -- output function
  PROCESS(state) IS
  BEGIN
    CASE state IS
      WHEN reset =>
        o <= "000";
      WHEN mul =>
        o <= "100";
      WHEN div =>
        o <= "101";
      WHEN com =>
        o <= "110";
      WHEN mul_h =>
        o <= "000";
      WHEN div_h =>
        o <= "001";
      WHEN com_h =>
        o <= "010";
      WHEN err =>
        o <= "011";
    END CASE;
  END PROCESS;

END FSM_arch;
