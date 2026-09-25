LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY controlVisualizacion IS
    GENERIC(N : POSITIVE := 4);
    PORT(
        A, B, Maximo, Decenas, Unidades : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        HexAlto, HexBajo : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Modo : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Error_A, Error_B, Signo : IN STD_LOGIC;
        Dato_A, Dato_B, Dato_Izq, Dato_Der : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        MenosIzq : OUT STD_LOGIC
    );
END ENTITY controlVisualizacion;

ARCHITECTURE combinacional OF controlVisualizacion IS
    CONSTANT Letra_E : STD_LOGIC_VECTOR(N-1 DOWNTO 0) :=
        (3 => '1', 2 => '1', 1 => '1', OTHERS => '0');
    SIGNAL ErrorGlobal : STD_LOGIC;
BEGIN
    ErrorGlobal <= Error_A OR Error_B;
    Dato_A <= Letra_E WHEN Error_A = '1' ELSE A;
    Dato_B <= Letra_E WHEN Error_B = '1' ELSE B;

    Dato_Izq <= Letra_E WHEN ErrorGlobal = '1' ELSE
                HexAlto WHEN Modo = "01" ELSE
                (OTHERS => '0') WHEN Modo = "10" ELSE Decenas;

    Dato_Der <= Letra_E WHEN ErrorGlobal = '1' ELSE
                HexBajo WHEN Modo = "01" ELSE
                Maximo WHEN Modo = "10" ELSE Unidades;

    MenosIzq <= Signo WHEN Modo = "00" AND ErrorGlobal = '0' ELSE '0';
END ARCHITECTURE combinacional;
