LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY multiplicador IS
    GENERIC(
        N : POSITIVE := 4
    );
    PORT(
        A : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        B : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR(2*N-1 DOWNTO 0)
    );
END ENTITY multiplicador;

ARCHITECTURE structural OF multiplicador IS

    TYPE filas IS ARRAY(0 TO N) OF STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);
    SIGNAL parcial : filas;
    SIGNAL suma    : filas;

BEGIN

    suma(0) <= (OTHERS => '0');
    parcial(N) <= (OTHERS => '0');

    productos: FOR i IN 0 TO N-1 GENERATE

        bits: FOR j IN 0 TO 2*N-1 GENERATE

            -- La fila i equivale a A AND B(i), desplazada i posiciones.
            datos: IF j >= i AND j < i+N GENERATE
                parcial(i)(j) <= A(j-i) AND B(i);
            END GENERATE;

            ceros: IF j < i OR j >= i+N GENERATE
                parcial(i)(j) <= '0';
            END GENERATE;

        END GENERATE;

        U1: ENTITY WORK.sumadorRestador
        GENERIC MAP(
            N => 2*N
        )
        PORT MAP(
            A        => suma(i),
            B        => parcial(i),
            Modo     => '0',
            S        => suma(i+1),
            Cout     => OPEN,
            Overflow => OPEN
        );

    END GENERATE;

    P <= suma(N);

END ARCHITECTURE structural;
