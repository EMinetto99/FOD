// Maestro - 1 Detalle - Varios registros pueden modificar el maestro.  


assign(maestro, 'maestro');
assign(detalle, 'detalle');
reset(maestro);	// Abro archivo maestro
reset(detalle);	// Abro archivo detalle
while not (EOF(detalle)) do begin	// Mientras el archivo detalle no llegó al fin
	read(maestro, regMaestro);		// Leo registro del maestro
	read(detalle, regDetalle);		// Leo registro del detalle
	while (regMaestro.cod <> regDetalle.cod) do	// Busco el dato en maestro que coincida con detalle
		read(maestro, regMaestro);				// Voy recorriendo el maestro hasta encontrar el dato

	codigoAct = regDetalle.cod;		// Obtengo el dato actual como corte de control
	total := 0;
	while (regDetalle.cod = codigoAct) do begin		// Si es el mismo dato del detalle
		total :=  total + regDetalle.stock;			// Acumulo
		read(detalle, regDetalle);					// Me muevo al siguiente registro
		end;

	regMaestro.stock := regMaestro.stock + total;	// Actualizo el dato, ya que al salir lo encontré (seguro existe)
	seek(maestro, filePos(maestro)-1);				// Reubico el puntero del archivo al la pos anterior.
	write(maestro, regMaestro);						// Actualizo escribiendo el maestro
	end;
close(maestro);
close(detalle);