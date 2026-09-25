onerror {abort}
set proyecto [pwd]
transcript file [file join $proyecto testbench resultado_simulacion.log]
if {![file isdirectory work]} {vlib work}
vmap work work

foreach archivo {
    fullAdder.vhd sumadorRestador.vhd multiplicador.vhd selectorResultado.vhd
    validadorBCD.vhd signoMagnitud.vhd binarioBCD.vhd decodificador7seg.vhd
    comparador.vhd prioridadBotones.vhd controlLED.vhd controlVisualizacion.vhd
    principal.vhd
} {
    vcom -93 -work work [file join $proyecto $archivo]
}
vcom -93 -work work [file join $proyecto testbench principal_auto_tb.vhd]
vsim -t 1ps work.principal_auto_tb
run -all

if {[string tolower [examine /principal_auto_tb/finalizado]] ne "true"} {
    error "La prueba no termino."
}
if {[examine -radix decimal /principal_auto_tb/casos_probados] != 8192} {
    error "No se ejecutaron los 8192 casos."
}
if {[examine -radix decimal /principal_auto_tb/errores] != 0} {
    error "FAIL: se encontraron discrepancias; revisar resultado_simulacion.log."
}
puts "PASS: 8192 casos, 0 casos con error."
