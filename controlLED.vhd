LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY controlLED IS
    GENERIC(N : POSITIVE := 8);
    PORT(
        Resultado : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Modo : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Mayor, Igual, Menor, Signo, ErrorGlobal : IN STD_LOGIC;
        LEDG : OUT STD_LOGIC_VECTOR(N+1 DOWNTO 0)
    );
END ENTITY controlLED;

ARCHITECTURE combinacional OF controlLED IS
    SIGNAL Comparacion : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
BEGIN
    Comparacion(2) <= Mayor;
    Comparacion(1) <= Igual;
    Comparacion(0) <= Menor;
    Comparacion(N-1 DOWNTO 3) <= (OTHERS => '0');

    LEDG(N-1 DOWNTO 0) <= Comparacion WHEN Modo = "10" ELSE Resultado;
    LEDG(N) <= Signo;
    LEDG(N+1) <= ErrorGlobal;
END ARCHITECTURE combinacional;
