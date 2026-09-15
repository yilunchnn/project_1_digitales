LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY principal IS
    PORT(
        SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        BUTTON : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        HEX0_D, HEX1_D, HEX2_D, HEX3_D : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX0_DP, HEX1_DP, HEX2_DP, HEX3_DP : OUT STD_LOGIC
    );
END ENTITY principal;

ARCHITECTURE structural OF principal IS
    SIGNAL Suma, Resta, Producto, Resultado, Magnitud : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL BCD : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Modo : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Maximo, Dato_A, Dato_B, Dato_Izq, Dato_Der : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Mayor, Igual, Menor, Signo, Error_A, Error_B, ErrorGlobal : STD_LOGIC;
    SIGNAL ValidarBCD, Prueba, MenosIzq : STD_LOGIC;
BEGIN

    U1: ENTITY WORK.sumadorRestador
    GENERIC MAP(N => 8)
    PORT MAP(
        A(7 DOWNTO 4) => "0000",
        A(3 DOWNTO 0) => SW(7 DOWNTO 4),
        B(7 DOWNTO 4) => "0000",
        B(3 DOWNTO 0) => SW(3 DOWNTO 0),
        Modo => '0',
        S => Suma,
        Cout => OPEN,
        Overflow => OPEN
    );

    U2: ENTITY WORK.sumadorRestador
    GENERIC MAP(N => 8)
    PORT MAP(
        A(7 DOWNTO 4) => "0000",
        A(3 DOWNTO 0) => SW(7 DOWNTO 4),
        B(7 DOWNTO 4) => "0000",
        B(3 DOWNTO 0) => SW(3 DOWNTO 0),
        Modo => '1',
        S => Resta,
        Cout => OPEN,
        Overflow => OPEN
    );

    U3: ENTITY WORK.multiplicador
    GENERIC MAP(N => 4)
    PORT MAP(
        A => SW(7 DOWNTO 4),
        B => SW(3 DOWNTO 0),
        P => Producto
    );

    U4: ENTITY WORK.selectorResultado
    GENERIC MAP(N => 8)
    PORT MAP(
        Suma => Suma,
        Resta => Resta,
        Producto => Producto,
        Sel => SW(9 DOWNTO 8),
        S => Resultado
    );

    U5: ENTITY WORK.prioridadBotones
    PORT MAP(
        BUTTON => BUTTON,
        Modo => Modo,
        ValidarBCD => ValidarBCD,
        Prueba => Prueba
    );

    U6: ENTITY WORK.validadorBCD
    GENERIC MAP(N => 4)
    PORT MAP(
        A => SW(7 DOWNTO 4),
        B => SW(3 DOWNTO 0),
        Habilitar => ValidarBCD,
        Error_A => Error_A,
        Error_B => Error_B,
        ErrorGlobal => ErrorGlobal
    );

    U7: ENTITY WORK.signoMagnitud
    GENERIC MAP(N => 8)
    PORT MAP(
        Resultado => Resultado,
        Operacion => SW(9 DOWNTO 8),
        Signo => Signo,
        Magnitud => Magnitud
    );

    U8: ENTITY WORK.binarioBCD
    GENERIC MAP(N => 8, DIGITOS => 3)
    PORT MAP(
        Binario => Magnitud,
        BCD => BCD
    );

    U9: ENTITY WORK.comparador
    GENERIC MAP(N => 4)
    PORT MAP(
        A => SW(7 DOWNTO 4),
        B => SW(3 DOWNTO 0),
        Mayor => Mayor,
        Igual => Igual,
        Menor => Menor,
        Maximo => Maximo
    );

    U10: ENTITY WORK.controlVisualizacion
    GENERIC MAP(N => 4)
    PORT MAP(
        A => SW(7 DOWNTO 4),
        B => SW(3 DOWNTO 0),
        Maximo => Maximo,
        Decenas => BCD(7 DOWNTO 4),
        Unidades => BCD(3 DOWNTO 0),
        HexAlto => Resultado(7 DOWNTO 4),
        HexBajo => Resultado(3 DOWNTO 0),
        Modo => Modo,
        Error_A => Error_A,
        Error_B => Error_B,
        Signo => Signo,
        Dato_A => Dato_A,
        Dato_B => Dato_B,
        Dato_Izq => Dato_Izq,
        Dato_Der => Dato_Der,
        MenosIzq => MenosIzq
    );

    U11: ENTITY WORK.controlLED
    GENERIC MAP(N => 8)
    PORT MAP(
        Resultado => Resultado,
        Modo => Modo,
        Mayor => Mayor,
        Igual => Igual,
        Menor => Menor,
        Signo => Signo,
        ErrorGlobal => ErrorGlobal,
        LEDG => LEDG
    );

    U12: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(
        Dato => Dato_A,
        Menos => '0',
        Blanco => '0',
        Prueba => Prueba,
        Segmentos => HEX3_D
    );

    U13: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(
        Dato => Dato_B,
        Menos => '0',
        Blanco => '0',
        Prueba => Prueba,
        Segmentos => HEX2_D
    );

    U14: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(
        Dato => Dato_Izq,
        Menos => MenosIzq,
        Blanco => '0',
        Prueba => Prueba,
        Segmentos => HEX1_D
    );

    U15: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(
        Dato => Dato_Der,
        Menos => '0',
        Blanco => '0',
        Prueba => Prueba,
        Segmentos => HEX0_D
    );

    -- La prueba enciende tambien los puntos decimales.
    HEX0_DP <= NOT Prueba;
    HEX1_DP <= NOT Prueba;
    HEX2_DP <= NOT Prueba;
    HEX3_DP <= NOT Prueba;

END ARCHITECTURE structural;
