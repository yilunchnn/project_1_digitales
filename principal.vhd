LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY principal IS
    PORT(
        SW   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        HEX0_D, HEX1_D, HEX2_D, HEX3_D : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        HEX0_DP, HEX1_DP, HEX2_DP, HEX3_DP : OUT STD_LOGIC
    );
END ENTITY principal;

ARCHITECTURE structural OF principal IS
    SIGNAL SumaResta, Producto : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL Resultado, Magnitud : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL BCD : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL Error_A, Error_B : STD_LOGIC;
    SIGNAL Signo : STD_LOGIC;
    SIGNAL Dato_A, Dato_B, Dato_Izq, Dato_Der : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    U1: ENTITY WORK.sumadorRestador
    GENERIC MAP(
        N => 8
    )
    PORT MAP(
        A(7 DOWNTO 4) => "0000",
        A(3 DOWNTO 0) => SW(7 DOWNTO 4),
        B(7 DOWNTO 4) => "0000",
        B(3 DOWNTO 0) => SW(3 DOWNTO 0),
        Modo         => SW(8),
        S            => SumaResta,
        Cout         => OPEN,
        Overflow     => OPEN
    );

    U2: ENTITY WORK.multiplicador
    GENERIC MAP(
        N => 4
    )
    PORT MAP(
        A => SW(7 DOWNTO 4),
        B => SW(3 DOWNTO 0),
        P => Producto
    );

    U3: ENTITY WORK.selectorResultado
    GENERIC MAP(
        N => 8
    )
    PORT MAP(
        SumaResta => SumaResta,
        Producto  => Producto,
        Sel       => SW(9 DOWNTO 8),
        S         => Resultado
    );

    LEDG(7 DOWNTO 0) <= Resultado;

    U4: ENTITY WORK.validadorBCD
    GENERIC MAP(
        N => 4
    )
    PORT MAP(
        A           => SW(7 DOWNTO 4),
        B           => SW(3 DOWNTO 0),
        Habilitar   => '1',
        Error_A     => Error_A,
        Error_B     => Error_B,
        ErrorGlobal => LEDG(9)
    );

    U5: ENTITY WORK.signoMagnitud
    GENERIC MAP(
        N => 8
    )
    PORT MAP(
        Resultado => Resultado,
        Operacion => SW(9 DOWNTO 8),
        Signo     => Signo,
        Magnitud  => Magnitud
    );

    U6: ENTITY WORK.binarioBCD
    GENERIC MAP(
        N       => 8,
        DIGITOS => 3
    )
    PORT MAP(
        Binario => Magnitud,
        BCD     => BCD
    );

    LEDG(8) <= Signo;

    U7: ENTITY WORK.controlDecimal
    GENERIC MAP(N => 4)
    PORT MAP(
        A => SW(7 DOWNTO 4),
        B => SW(3 DOWNTO 0),
        Decenas => BCD(7 DOWNTO 4),
        Unidades => BCD(3 DOWNTO 0),
        Error_A => Error_A,
        Error_B => Error_B,
        Signo => Signo,
        Dato_A => Dato_A,
        Dato_B => Dato_B,
        Dato_Izq => Dato_Izq,
        Dato_Der => Dato_Der
    );

    -- De izquierda a derecha: A, B, decenas/signo, unidades.
    U8: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(Dato => Dato_A, Segmentos => HEX3_D);

    U9: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(Dato => Dato_B, Segmentos => HEX2_D);

    U10: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(Dato => Dato_Izq, Segmentos => HEX1_D);

    U11: ENTITY WORK.decodificador7seg
    GENERIC MAP(N => 4)
    PORT MAP(Dato => Dato_Der, Segmentos => HEX0_D);

    -- Puntos decimales apagados.
    HEX0_DP <= '1';
    HEX1_DP <= '1';
    HEX2_DP <= '1';
    HEX3_DP <= '1';

END ARCHITECTURE structural;
