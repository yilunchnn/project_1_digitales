LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY signoMagnitud IS
    GENERIC(
        N : POSITIVE := 8
    );
    PORT(
        Resultado : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Operacion : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        Signo     : OUT STD_LOGIC;
        Magnitud  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY signoMagnitud;

ARCHITECTURE structural OF signoMagnitud IS
    SIGNAL Negativo : STD_LOGIC;
    SIGNAL Opuesto  : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
BEGIN

    -- Solo una resta (01) puede tener signo negativo.
    Negativo <= NOT Operacion(1) AND Operacion(0) AND Resultado(N-1);
    Signo <= Negativo;

    U1: ENTITY WORK.sumadorRestador
    GENERIC MAP(
        N => N
    )
    PORT MAP(
        A        => (OTHERS => '0'),
        B        => Resultado,
        Modo     => '1',
        S        => Opuesto,
        Cout     => OPEN,
        Overflow => OPEN
    );

    bits: FOR i IN 0 TO N-1 GENERATE
        Magnitud(i) <= (Resultado(i) AND NOT Negativo) OR
                       (Opuesto(i) AND Negativo);
    END GENERATE;

END ARCHITECTURE structural;
