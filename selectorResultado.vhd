LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY selectorResultado IS
    GENERIC(
        N : POSITIVE := 8
    );
    PORT(
        Suma, Resta : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Producto  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Sel       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        S         : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY selectorResultado;

ARCHITECTURE gatelevel OF selectorResultado IS
BEGIN

    -- 00 suma, 01 resta, 10 producto, 11 cero.
    bits: FOR i IN 0 TO N-1 GENERATE
        S(i) <= (Suma(i) AND NOT Sel(1) AND NOT Sel(0)) OR
                (Resta(i) AND NOT Sel(1) AND Sel(0)) OR
                (Producto(i) AND Sel(1) AND NOT Sel(0));
    END GENERATE;

END ARCHITECTURE gatelevel;
