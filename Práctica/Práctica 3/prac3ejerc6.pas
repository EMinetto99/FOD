program prac3ejer6;
const
	valorAlto = 9999;
type
	cadena30 = string[30];
	prenda = record
		cod: integer;
		desc: cadena30;
		color: cadena30;
		tipo: cadena30;
		stock: integer;
		precioUnit: real;
		end;
	arch_prendas = File of prenda;
	arch_prendasObsoletas = File of integer;
procedure leer(var arch: arch_prendasObsoletas; var cod: integer);
	begin
		if (not EOF(arch)) then
			read(arch, cod)
			else
				cod := valorAlto;
	end;
procedure procesoBaja(var archP: arch_prendas; var archO: arch_prendasObsoletas);
	var
		codigoActual: integer;
		regPrendas: prenda;
	begin
		leer(archO, codigoActual);				// Leo detalle
		while (codigoActual <> valorAlto) do begin	
			read(archP, regPrendas);			// Leo maestro
			while (not EOF(archP)) do begin
				if (regPrendas.cod = codigoActual) then begin
					regPrendas.stock := -1;				// Marca eliminación de registro
					seek(archP, filePos(archP)-1);	// Voy hacia atras
					write(archP, regPrendas);		// Escribo el registro
					seek(archP, filePos(archP)+1);	// Voy hacia delante
					end;
				read(archP, regPrendas);
				end;
			leer(archO, codigoActual);			// Leo detalle
			end;
	end;
procedure procesoCompactacion(var archP: arch_prendas);
	var
		archActualizado: arch_prendas;
		regPrendas: prenda;
	begin
		assign(archActualizado, 'archivo_prendas_actualizado');
		rewrite(archActualizado);
		while (not EOF(archP)) do begin
			read(archP, regPrendas);
			if (regPrendas.stock <> -1) then
				write(archActualizado, regPrendas);
			end;
		close(archActualizado);
		assign(archActualizado, 'archivo_prendas');
	end;
var
	archPrendas: arch_prendas;
	archPrendasObs: arch_prendasObsoletas;
begin
	assign(archPrendas, 'archivo_prendas');
	assign(archPrendasObs, 'prendas_obsoletas');
	reset(archPrendas);
	reset(archPrendasObs);
	procesoBaja(archPrendas, archPrendasObs);
	procesoCompactacion(archPrendas);
	close(archPrendas);
	close(archPrendasObs);
	readln;
end.