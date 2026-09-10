LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY principal IS
    PORT(
        SW   : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
        LEDG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY principal;

ARCHITECTURE structural OF principal IS
    SIGNAL A, B : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

    A <= "0000" & SW(7 DOWNTO 4);
    B <= "0000" & SW(3 DOWNTO 0);

    U1: ENTITY WORK.sumadorRestador
    GENERIC MAP(
        N => 8
    )
    PORT MAP(
        A        => A,
        B        => B,
        Modo     => SW(8),
        S        => LEDG,
        Cout     => OPEN,
        Overflow => OPEN
    );

END ARCHITECTURE structural;
