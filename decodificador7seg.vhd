LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY decodificador7seg IS
    GENERIC(
        N : POSITIVE := 4
    );
    PORT(
        Dato      : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Menos     : IN STD_LOGIC := '0';
        Blanco    : IN STD_LOGIC := '0';
        Prueba    : IN STD_LOGIC := '0';
        Segmentos : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY decodificador7seg;

ARCHITECTURE combinacional OF decodificador7seg IS
    SIGNAL Patron : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL Digito : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

    WITH Dato(3 DOWNTO 0) SELECT
        Patron <= "1000000" WHEN "0000", -- 0
                  "1111001" WHEN "0001", -- 1
                  "0100100" WHEN "0010", -- 2
                  "0110000" WHEN "0011", -- 3
                  "0011001" WHEN "0100", -- 4
                  "0010010" WHEN "0101", -- 5
                  "0000010" WHEN "0110", -- 6
                  "1111000" WHEN "0111", -- 7
                  "0000000" WHEN "1000", -- 8
                  "0010000" WHEN "1001", -- 9
                  "0001000" WHEN "1010", -- A
                  "0000011" WHEN "1011", -- b
                  "1000110" WHEN "1100", -- C
                  "0100001" WHEN "1101", -- d
                  "0000110" WHEN "1110", -- E
                  "0001110" WHEN "1111", -- F
                  "1111111" WHEN OTHERS;

    cuatro_bits: IF N = 4 GENERATE
        Digito <= Patron;
    END GENERATE;

    mas_bits: IF N > 4 GENERATE
        Digito <= Patron WHEN Dato(N-1 DOWNTO 4) = (N-1 DOWNTO 4 => '0')
                     ELSE "1111111";
    END GENERATE;

    Segmentos <= "0000000" WHEN Prueba = '1' ELSE
                 "1111111" WHEN Blanco = '1' ELSE
                 "0111111" WHEN Menos = '1' ELSE Digito;

END ARCHITECTURE combinacional;
