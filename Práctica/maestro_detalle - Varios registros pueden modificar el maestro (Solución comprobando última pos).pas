// Maestro - 1 Detalle - Varios registros pueden modificar el maestro (Solución comprobando última pos).

const
	valorAlto = 9999;

procedure leer(var detalle: archivo_detalle; var regDet: registroDetalle);
	begin
		if (not EOF(detalle)) then			// Si no se termino el datelle
			read(detalle, regDet)			// Leo el registro
			else
				regDet.cod := valorAlto;	// Si se terminó asigno corte de control
	end;
begin
	assign(maestro, 'maestro');
	assign(detalle, 'detalle');
	reset(maestro);	// Abro archivo maestro
	reset(detalle);	// Abro archivo detalle
	read(maestro, regMaestro);		// Leo registro del maestro
	leer(detalle, regDetalle);		// Leo archivo detalle

	while (regDetalle.cod <> valorAlto) do begin	// Si el archivo detalle no se terminó 
		aux := regDetalle.cod;						// Tomo código actual
		total := 0;						// Inicializo el totalizador
		while (aux = regDetalle.cod) do begin		// Si el dato del detalle sigue siendo el mismo
			total := total + detalle.stock;			// Acumulo
			leer(detalle, regDetalle);				// Leo el siguiente registro del detalle
			end;
		while (regMaestro.cod <> aux) do		// Si el dato del detalle es distinto del maestro, busco el mismo dato
			read(maestro, regMaestro);			// muevo el puntero en el maestro

		regMaestro.stock := regMaestro.stock + total;	// Actualizo el dato, ya que al salir lo encontré (seguro existe)
		seek(maestro, filePos(maestro)-1);				// Reubico el puntero del archivo al la pos anterior.
		write(maestro, regMaestro);						// Actualizo escribiendo el maestro
		if (not EOF(maestro)) then				// Si el archivo maestro no termino
			read(maestro, regMaestro);			// Leo el siguiente dato del maestro
	end;
	close(maestro);
	close(detalle);
end.