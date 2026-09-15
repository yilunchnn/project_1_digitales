LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY prioridadBotones IS
    PORT(
        BUTTON : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Modo : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ValidarBCD, Prueba : OUT STD_LOGIC
    );
END ENTITY prioridadBotones;

ARCHITECTURE gatelevel OF prioridadBotones IS
    SIGNAL Codigo : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    -- Boton presionado = 0. Prioridad: BUTTON2 > BUTTON1 > BUTTON0.
    -- 00 decimal, 01 hexadecimal, 10 comparador, 11 prueba.
    Codigo(1) <= NOT BUTTON(2) OR NOT BUTTON(1);
    Codigo(0) <= NOT BUTTON(2) OR (BUTTON(1) AND NOT BUTTON(0));
    Modo <= Codigo;

    -- La validacion solo se desactiva cuando gana el modo hexadecimal.
    ValidarBCD <= Codigo(1) OR NOT Codigo(0);
    Prueba <= NOT BUTTON(2);
END ARCHITECTURE gatelevel;
