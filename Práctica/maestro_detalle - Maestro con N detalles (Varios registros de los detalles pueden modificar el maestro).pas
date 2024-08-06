// Maestro - n Detalles - Varios registros de los detalles pueden modificar el maestro (Solución comprobando última pos).

const
	valorAlto = 9999;

procedure leer(var detalle: archivo_detalle; var regDet: registroDetalle);
	begin
		if (not EOF(detalle)) then			// Si no se termino el datelle
			read(detalle, regDet)			// Leo el registro
			else
				regDet.cod := valorAlto;	// Si se terminó asigno corte de control
	end;
procedure minimo(var d1, d2, d3: archivo_detalle; var r1, r2, r3, min: registroDetalle);
	begin
		if (d1.cod <= d2.cod) and (d1.cod <= d3.cod) then begin
			min := r1;
			leer(d1, r1);
			end
			else if (d2.cod <= d3.cod) then begin
				min := r2;
				leer(d2, r2);
				end
				else begin
					min := r3;
					leer(d3, r3);
					end
			end;
	end;
begin
	assign(maestro, 'maestro');
	assign(detalle1, 'detalle_1');
	assign(detalle2, 'detalle_2');
	assign(detalle3, 'detalle_3');
	reset(maestro);		// Abro archivo maestro
	reset(detalle1);	// Abro archivo detalle 1
	reset(detalle2);	// Abro archivo detalle 2
	reset(detalle3);	// Abro archivo detalle 3
	read(maestro, regMaestro);		// Leo registro del maestro
	minimo(detalle1, detalle2, detalle3, regDet1, regDet2, regDet3, minimo);	// Obtengo el minimo entre los detalles

	while (minimo.cod <> valorAlto) do begin	// Si el archivo detalle no se terminó 
		aux := minimo.cod;						// Tomo código actual
		total := 0;								// Inicializo el totalizador
		while (aux = minimo.cod) do begin		// Si el dato del detalle sigue siendo el mismo
			total := total + minimo.stock;			// Acumulo
			minimo(detalle1, detalle2, detalle3, regDet1, regDet2, regDet3, minimo); // Siguiente reg. minimo de los detalles
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
	close(detalle1);
	close(detalle2);
	close(detalle3);
end.