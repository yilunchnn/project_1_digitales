LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY fullAdder IS
    PORT(
        A    : IN  STD_LOGIC;
        B    : IN  STD_LOGIC;
        Cin  : IN  STD_LOGIC;
        S    : OUT STD_LOGIC;
        Cout : OUT STD_LOGIC
    );
END ENTITY fullAdder;

ARCHITECTURE gatelevel OF fullAdder IS
BEGIN

    S <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (A AND Cin) OR (B AND Cin);

END ARCHITECTURE gatelevel;
