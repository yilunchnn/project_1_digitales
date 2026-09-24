LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY binarioBCD IS
    GENERIC(
        N       : POSITIVE := 8;
        DIGITOS : POSITIVE := 3
    );
    PORT(
        Binario : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        BCD     : OUT STD_LOGIC_VECTOR(4*DIGITOS-1 DOWNTO 0)
    );
END ENTITY binarioBCD;

ARCHITECTURE structural OF binarioBCD IS
    TYPE filas IS ARRAY(NATURAL RANGE <>) OF
        STD_LOGIC_VECTOR(4*DIGITOS-1 DOWNTO 0);
    SIGNAL etapa    : filas(0 TO N);
    SIGNAL ajustada : filas(0 TO N-1);
BEGIN

    etapa(0) <= (OTHERS => '0');

    pasos: FOR i IN 0 TO N-1 GENERATE

        cifras: FOR j IN 0 TO DIGITOS-1 GENERATE
            SIGNAL Dato, Ajuste : STD_LOGIC_VECTOR(3 DOWNTO 0);
        BEGIN

            Dato <= etapa(i)(4*j+3 DOWNTO 4*j);
            -- Antes de desplazar, suma 3 a cada cifra mayor que 4.
            Ajuste <= "0011" WHEN Dato > "0100" ELSE "0000";

            U1: ENTITY WORK.sumadorRestador
            GENERIC MAP(
                N => 4
            )
            PORT MAP(
                A        => Dato,
                B        => Ajuste,
                Modo     => '0',
                S        => ajustada(i)(4*j+3 DOWNTO 4*j),
                Cout     => OPEN,
                Overflow => OPEN
            );

        END GENERATE;

        -- Desplaza e introduce el siguiente bit, empezando por el mayor.
        etapa(i+1) <= ajustada(i)(4*DIGITOS-2 DOWNTO 0) & Binario(N-1-i);

    END GENERATE;

    BCD <= etapa(N);

END ARCHITECTURE structural;
