LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY sumadorRestador IS
    GENERIC(
        N : POSITIVE := 8
    );

    PORT(
        A        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        B        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Modo     : IN  STD_LOGIC;
        S        : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Cout     : OUT STD_LOGIC;
        Overflow : OUT STD_LOGIC
    );
END ENTITY sumadorRestador;

ARCHITECTURE structural OF sumadorRestador IS

    SIGNAL C     : STD_LOGIC_VECTOR(N DOWNTO 0);
    SIGNAL B_aux : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

    -- Modo = 0 suma, Modo = 1 resta.
    C(0) <= Modo;

    sumadores: FOR i IN 0 TO N-1 GENERATE

        B_aux(i) <= B(i) XOR Modo;

        FA: ENTITY WORK.fullAdder
        PORT MAP(
            A    => A(i),
            B    => B_aux(i),
            Cin  => C(i),
            S    => S(i),
            Cout => C(i+1)
        );

    END GENERATE;

    Cout <= C(N);
    Overflow <= C(N) XOR C(N-1);

END ARCHITECTURE structural;
