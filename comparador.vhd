LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY comparador IS
    GENERIC(N : POSITIVE := 4);
    PORT(
        A, B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Mayor, Igual, Menor : OUT STD_LOGIC;
        Maximo : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY comparador;

ARCHITECTURE combinacional OF comparador IS
    SIGNAL A_mayor : STD_LOGIC;
BEGIN
    A_mayor <= '1' WHEN A > B ELSE '0';
    Mayor <= A_mayor;
    Igual <= '1' WHEN A = B ELSE '0';
    Menor <= '1' WHEN A < B ELSE '0';

    bits: FOR i IN 0 TO N-1 GENERATE
        Maximo(i) <= (A(i) AND A_mayor) OR (B(i) AND NOT A_mayor);
    END GENERATE;
END ARCHITECTURE combinacional;
