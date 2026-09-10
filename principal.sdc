# Presupuesto de esta prueba: 100 ns desde un switch hasta un LED.
# Son limites para las rutas combinacionales; no se crea un reloj.
set_max_delay 100.000 -from [all_inputs] -to [all_outputs]
set_min_delay 0.000 -from [all_inputs] -to [all_outputs]
