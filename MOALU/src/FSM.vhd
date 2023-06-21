library ieee;

use ieee.std_logic_1164.all;

entity FSM is
  port(
    clk        : in  std_logic;
    rst        : in  std_logic;
    enable     : in  std_logic;
    ready      : in  std_logic;
    op         : in  std_logic_vector(1 downto 0);
    alu_enable : out std_logic;
    alu_op     : out std_logic_vector(1 downto 0)
    );
end FSM;

architecture FSM_arch of FSM is
  type state_type is (reset, mod1, mod2, mod3, hold1, hold2, hold3, err);
  signal state      : state_type := reset;
  signal next_state : state_type;
  signal o          : std_logic_vector(2 downto 0);
  signal i          : std_logic_vector(2 downto 0);
begin

  i          <= ready & op;
  alu_enable <= o(2);
  alu_op     <= o(1 downto 0);

  -- set state
  process(clk, rst) is
  begin
    if rst = '1' then
      state <= reset;
    elsif (clk'event and clk = '1' and enable = '1') then
      state <= next_state;
    end if;
  end process;

  -- next state function
  process(i, state) is
  begin
    case state is

      when reset =>
        case i is
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when "111" =>
            next_state <= err;
          when others =>
            next_state <= reset;
        end case;

      when mod1 =>
        case i is
          when "000" =>
            next_state <= hold1;
          when "001" =>
            next_state <= mod2;
          when "010" =>
            next_state <= mod3;
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

      when mod2 =>
        case i is
          when "000" =>
            next_state <= mod1;
          when "001" =>
            next_state <= hold2;
          when "010" =>
            next_state <= mod3;
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

      when mod3 =>
        case i is
          when "000" =>
            next_state <= mod1;
          when "001" =>
            next_state <= mod2;
          when "010" =>
            next_state <= hold3;
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

      when hold1 =>
        case i is
          when "000" =>
            next_state <= hold1;
          when "001" =>
            next_state <= mod2;
          when "010" =>
            next_state <= mod3;
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

      when hold2 =>
        case i is
          when "000" =>
            next_state <= mod1;
          when "001" =>
            next_state <= hold2;
          when "010" =>
            next_state <= mod3;
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

      when hold3 =>
        case i is
          when "000" =>
            next_state <= mod1;
          when "001" =>
            next_state <= mod2;
          when "010" =>
            next_state <= hold3;
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

      when err =>
        case i is
          when "100" =>
            next_state <= mod1;
          when "101" =>
            next_state <= mod2;
          when "110" =>
            next_state <= mod3;
          when others =>
            next_state <= err;
        end case;

    end case;
  end process;

  -- output function
  process(state) is
  begin
    case state is
      when reset =>
        o <= "000";
      when mod1 =>
        o <= "100";
      when mod2 =>
        o <= "101";
      when mod3 =>
        o <= "110";
      when hold1 =>
        o <= "000";
      when hold2 =>
        o <= "001";
      when hold3 =>
        o <= "010";
      when err =>
        o <= "011";
    end case;
  end process;

end FSM_arch;
