program prac2ejerc9;
const
	valorAlto = 9999;
type
	mesa_elec = record
		codProv: integer;
		codLoc: integer;
		nMesa: integer;
		cantVotos: integer;
		end;

	archivo = File of mesa_elec;
procedure leer(var arch: archivo; var reg: mesa_elec);
	begin
		if (not EOF(arch)) then
			read(arch, reg)
			else
				reg.codProv := valorAlto;
	end;
var
	arch: archivo;
	regArchivo: mesa_elec;
	provAct, locAct, totalVotosLoc, totalVotosProv, total: integer;
begin
	assign(arch, 'archivo_electoral');
	reset(arch);
	total := 0;
	leer(arch, regArchivo)
	while (regArchivo <> valorAlto) do begin
		totalVotosProv := 0;
		provAct := regArchivo.codProv;
		writeln('Codigo de la provincia: ',provAct);
		while (regArchivo.codProv = provAct) do begin
			totalVotosLoc := 0;
			locAct := regArchivo.codLoc;
			writeln('Codigo de localidad: ',locAct);
			while (regArchivo.codLoc = locAct) and (regArchivo.codProv = provAct) do begin
				totalVotosLoc := totalVotosLoc + regArchivo.cantVotos;
				leer(arch, regArchivo);
				end;
			totalVotosProv := totalVotosProv + totalVotosLoc;
			writeln('Total de votos en la localidad: ',totalVotosLoc);
			end;
		total := total + totalVotosProv;	
		end;
	writeln('Total general de votos: ',total);
	end;
end.