LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY validadorBCD IS
    GENERIC(
        N : POSITIVE := 4   -- N debe ser mayor o igual a 4.
    );
    PORT(
        A, B        : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Habilitar   : IN  STD_LOGIC;
        Error_A     : OUT STD_LOGIC;
        Error_B     : OUT STD_LOGIC;
        ErrorGlobal : OUT STD_LOGIC
    );
END ENTITY validadorBCD;

ARCHITECTURE gatelevel OF validadorBCD IS
    CONSTANT Nueve : STD_LOGIC_VECTOR(N-1 DOWNTO 0) :=
        (3 => '1', 0 => '1', OTHERS => '0');
    SIGNAL EA, EB : STD_LOGIC;
BEGIN

    -- Habilitar = 0 se usara despues para el modo hexadecimal.
    EA <= Habilitar WHEN A > Nueve ELSE '0';
    EB <= Habilitar WHEN B > Nueve ELSE '0';

    Error_A <= EA;
    Error_B <= EB;
    ErrorGlobal <= EA OR EB;

END ARCHITECTURE gatelevel;
