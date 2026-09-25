LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY principal_auto_tb IS
END ENTITY principal_auto_tb;

ARCHITECTURE test OF principal_auto_tb IS
    SIGNAL SW_tb, LEDG_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL BUTTON_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL HEX0_tb, HEX1_tb, HEX2_tb, HEX3_tb : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL DP_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL casos_probados, errores : NATURAL := 0;
    SIGNAL finalizado : BOOLEAN := false;

    FUNCTION bits(valor : NATURAL; ancho : POSITIVE) RETURN STD_LOGIC_VECTOR IS
        VARIABLE numero : NATURAL := valor;
        VARIABLE salida : STD_LOGIC_VECTOR(ancho-1 DOWNTO 0);
    BEGIN
        FOR i IN 0 TO ancho-1 LOOP
            IF numero MOD 2 = 1 THEN salida(i) := '1';
            ELSE salida(i) := '0'; END IF;
            numero := numero / 2;
        END LOOP;
        RETURN salida;
    END FUNCTION;

    FUNCTION segmentos(digito : NATURAL) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        CASE digito IS
            WHEN 0  => RETURN "1000000";
            WHEN 1  => RETURN "1111001";
            WHEN 2  => RETURN "0100100";
            WHEN 3  => RETURN "0110000";
            WHEN 4  => RETURN "0011001";
            WHEN 5  => RETURN "0010010";
            WHEN 6  => RETURN "0000010";
            WHEN 7  => RETURN "1111000";
            WHEN 8  => RETURN "0000000";
            WHEN 9  => RETURN "0010000";
            WHEN 10 => RETURN "0001000";
            WHEN 11 => RETURN "0000011";
            WHEN 12 => RETURN "1000110";
            WHEN 13 => RETURN "0100001";
            WHEN 14 => RETURN "0000110";
            WHEN 15 => RETURN "0001110";
            WHEN 16 => RETURN "0111111";
            WHEN OTHERS => RETURN "1111111";
        END CASE;
    END FUNCTION;

    FUNCTION texto(valor : STD_LOGIC_VECTOR) RETURN STRING IS
        VARIABLE salida : STRING(1 TO valor'LENGTH);
        VARIABLE j : POSITIVE := 1;
    BEGIN
        FOR i IN valor'RANGE LOOP
            CASE valor(i) IS
                WHEN '0' => salida(j) := '0';
                WHEN '1' => salida(j) := '1';
                WHEN OTHERS => salida(j) := '?';
            END CASE;
            j := j + 1;
        END LOOP;
        RETURN salida;
    END FUNCTION;

    PROCEDURE comparar(nombre : STRING; actual, esperado : STD_LOGIC_VECTOR) IS
    BEGIN
        ASSERT actual = esperado
            REPORT nombre & " esperado=" & texto(esperado) &
                   " obtenido=" & texto(actual)
            SEVERITY WARNING;
    END PROCEDURE;
BEGIN
    DUT: ENTITY WORK.principal
    PORT MAP(
        SW => SW_tb, BUTTON => BUTTON_tb, LEDG => LEDG_tb,
        HEX0_D => HEX0_tb, HEX1_D => HEX1_tb,
        HEX2_D => HEX2_tb, HEX3_D => HEX3_tb,
        HEX0_DP => DP_tb(0), HEX1_DP => DP_tb(1),
        HEX2_DP => DP_tb(2), HEX3_DP => DP_tb(3)
    );

    PROCESS
        VARIABLE boton : STD_LOGIC_VECTOR(2 DOWNTO 0);
        VARIABLE modo : NATURAL;
        VARIABLE resultado : INTEGER;
        VARIABLE binario, magnitud, maximo : NATURAL;
        VARIABLE error_a, error_b : BOOLEAN;
        VARIABLE led : STD_LOGIC_VECTOR(9 DOWNTO 0);
        VARIABLE h0, h1, h2, h3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
        VARIABLE dp : STD_LOGIC_VECTOR(3 DOWNTO 0);
        VARIABLE total, fallos : NATURAL := 0;
    BEGIN
        FOR botones IN 0 TO 7 LOOP
            boton := bits(botones, 3);
            IF boton(2) = '0' THEN modo := 3;
            ELSIF boton(1) = '0' THEN modo := 2;
            ELSIF boton(0) = '0' THEN modo := 1;
            ELSE modo := 0; END IF;

            FOR operacion IN 0 TO 3 LOOP
                FOR a IN 0 TO 15 LOOP
                    FOR b IN 0 TO 15 LOOP
                        BUTTON_tb <= boton;
                        SW_tb <= bits(operacion, 2) & bits(a, 4) & bits(b, 4);

                        CASE operacion IS
                            WHEN 0 => resultado := a + b;
                            WHEN 1 => resultado := a - b;
                            WHEN 2 => resultado := a * b;
                            WHEN OTHERS => resultado := 0;
                        END CASE;
                        binario := (resultado + 256) MOD 256;
                        magnitud := ABS resultado;
                        IF a > b THEN maximo := a; ELSE maximo := b; END IF;
                        error_a := a > 9 AND modo /= 1;
                        error_b := b > 9 AND modo /= 1;

                        led := (OTHERS => '0');
                        IF modo = 2 THEN
                            IF a > b THEN led(2) := '1';
                            ELSIF a = b THEN led(1) := '1';
                            ELSE led(0) := '1'; END IF;
                        ELSE
                            led(7 DOWNTO 0) := bits(binario, 8);
                        END IF;
                        IF resultado < 0 THEN led(8) := '1'; END IF;
                        IF error_a OR error_b THEN led(9) := '1'; END IF;

                        h3 := segmentos(a);
                        h2 := segmentos(b);
                        dp := "1111";
                        IF error_a THEN h3 := segmentos(14); END IF;
                        IF error_b THEN h2 := segmentos(14); END IF;

                        IF modo = 3 THEN
                            h3 := "0000000"; h2 := "0000000";
                            h1 := "0000000"; h0 := "0000000";
                            dp := "0000";
                        ELSIF error_a OR error_b THEN
                            h1 := segmentos(14); h0 := segmentos(14);
                        ELSIF modo = 1 THEN
                            h1 := segmentos(binario / 16);
                            h0 := segmentos(binario MOD 16);
                        ELSIF modo = 2 THEN
                            h1 := segmentos(0); h0 := segmentos(maximo);
                        ELSE
                            IF resultado < 0 THEN h1 := segmentos(16);
                            ELSE h1 := segmentos(magnitud / 10); END IF;
                            h0 := segmentos(magnitud MOD 10);
                        END IF;

                        WAIT FOR 100 ns;
                        total := total + 1;
                        IF LEDG_tb /= led OR HEX3_tb /= h3 OR HEX2_tb /= h2 OR
                           HEX1_tb /= h1 OR HEX0_tb /= h0 OR DP_tb /= dp THEN
                            fallos := fallos + 1;
                            REPORT "ERROR caso=" & INTEGER'IMAGE(total) &
                                   " BUTTON=" & texto(boton) &
                                   " op=" & INTEGER'IMAGE(operacion) &
                                   " A=" & INTEGER'IMAGE(a) & " B=" & INTEGER'IMAGE(b)
                                SEVERITY WARNING;
                            comparar("LEDG", LEDG_tb, led);
                            comparar("HEX3", HEX3_tb, h3);
                            comparar("HEX2", HEX2_tb, h2);
                            comparar("HEX1", HEX1_tb, h1);
                            comparar("HEX0", HEX0_tb, h0);
                            comparar("DP", DP_tb, dp);
                        END IF;
                        casos_probados <= total;
                        errores <= fallos;
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;

        finalizado <= true;
        REPORT "FINAL: casos=" & INTEGER'IMAGE(total) &
               " casos con error=" & INTEGER'IMAGE(fallos);
        IF fallos = 0 THEN
            REPORT "PASS: todas las salidas coinciden con el modelo de referencia";
        ELSE
            REPORT "FAIL: revisar los casos indicados arriba" SEVERITY ERROR;
        END IF;
        WAIT;
    END PROCESS;
END ARCHITECTURE test;
