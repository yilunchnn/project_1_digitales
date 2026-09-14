LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY controlDecimal IS
    GENERIC(
        N : POSITIVE := 4   -- N debe ser mayor o igual a 4.
    );
    PORT(
        A, B, Decenas, Unidades : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Error_A, Error_B, Signo : IN STD_LOGIC;
        Dato_A, Dato_B          : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Dato_Izq, Dato_Der      : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY controlDecimal;

ARCHITECTURE combinacional OF controlDecimal IS
    CONSTANT Letra_E : STD_LOGIC_VECTOR(N-1 DOWNTO 0) :=
        (3 => '1', 2 => '1', 1 => '1', OTHERS => '0');
    CONSTANT Menos : STD_LOGIC_VECTOR(N-1 DOWNTO 0) :=
        (3 => '1', 1 => '1', OTHERS => '0');
    SIGNAL ErrorGlobal : STD_LOGIC;
BEGIN

    ErrorGlobal <= Error_A OR Error_B;

    Dato_A <= Letra_E WHEN Error_A = '1' ELSE A;
    Dato_B <= Letra_E WHEN Error_B = '1' ELSE B;

    -- El error tiene prioridad sobre el signo y el resultado.
    Dato_Izq <= Letra_E WHEN ErrorGlobal = '1' ELSE
                Menos WHEN Signo = '1' ELSE Decenas;

    Dato_Der <= Letra_E WHEN ErrorGlobal = '1' ELSE Unidades;

END ARCHITECTURE combinacional;
