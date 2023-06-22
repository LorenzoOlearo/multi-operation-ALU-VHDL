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
  TYPE state_type IS (reset, mod1, mod2, mod3, hold1, hold2, hold3, err);
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
    IF rst = '1' THEN
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
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN "111" =>
            next_state <= err;
          WHEN OTHERS =>
            next_state <= reset;
        END CASE;

      WHEN mod1 =>
        CASE i IS
          WHEN "000" =>
            next_state <= hold1;
          WHEN "001" =>
            next_state <= mod2;
          WHEN "010" =>
            next_state <= mod3;
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN mod2 =>
        CASE i IS
          WHEN "000" =>
            next_state <= mod1;
          WHEN "001" =>
            next_state <= hold2;
          WHEN "010" =>
            next_state <= mod3;
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN mod3 =>
        CASE i IS
          WHEN "000" =>
            next_state <= mod1;
          WHEN "001" =>
            next_state <= mod2;
          WHEN "010" =>
            next_state <= hold3;
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN hold1 =>
        CASE i IS
          WHEN "000" =>
            next_state <= hold1;
          WHEN "001" =>
            next_state <= mod2;
          WHEN "010" =>
            next_state <= mod3;
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN hold2 =>
        CASE i IS
          WHEN "000" =>
            next_state <= mod1;
          WHEN "001" =>
            next_state <= hold2;
          WHEN "010" =>
            next_state <= mod3;
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN hold3 =>
        CASE i IS
          WHEN "000" =>
            next_state <= mod1;
          WHEN "001" =>
            next_state <= mod2;
          WHEN "010" =>
            next_state <= hold3;
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
          WHEN OTHERS =>
            next_state <= err;
        END CASE;

      WHEN err =>
        CASE i IS
          WHEN "100" =>
            next_state <= mod1;
          WHEN "101" =>
            next_state <= mod2;
          WHEN "110" =>
            next_state <= mod3;
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
      WHEN mod1 =>
        o <= "100";
      WHEN mod2 =>
        o <= "101";
      WHEN mod3 =>
        o <= "110";
      WHEN hold1 =>
        o <= "000";
      WHEN hold2 =>
        o <= "001";
      WHEN hold3 =>
        o <= "010";
      WHEN err =>
        o <= "011";
    END CASE;
  END PROCESS;

END FSM_arch;
