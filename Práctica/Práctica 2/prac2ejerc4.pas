program prac2ejerc4;
const
	valorAlto = 'ZZZZ';

type
	cadena30 = string[30];

	dato = record
		nomProv: cadena30;
		cantPA: integer;
		totalEnc: integer;
		end;
	reg_datoAgencia = record
		nomProv: cadena30;
		codLoc: integer;
		cantAlfab: integer;
		cantEnc: integer;
		end;

	arch_maestro = File of dato;
	arch_detalle = File of reg_datoAgencia;
procedure leer(var arch: arch_detalle; var reg: reg_datoAgencia);
	begin
		if (not EOF(arch)) then
			read(arch, reg)
			else
				reg.nomProv := valorAlto;
	end;
procedure minimo(var d1, d2: arch_detalle; var r1, r2, min: reg_datoAgencia);
	begin
		if (r1.nomProv <= r2.nomProv) then begin
			min := r1;
			leer(d1, r1);
			end
			else begin
				min:= r2;
				leer(d2, r2);
				end;
	end;
var
	archM: arch_maestro;
	archD1: arch_detalle;
	archD2: arch_detalle;
	totalEnc, totalAlfab: integer;
	regMaestro: dato;
	regDetalle1, regDetalle2, min: reg_datoAgencia;
	aux: cadena30;
begin
	assign(archM, 'maestro');
	assign(archD1, 'detalle_1');
	assign(archD2, 'detalle_2');
	reset(archM);
	reset(archD1);
	reset(archD2);
	read(archM, regMaestro);
	leer(archD1, regDetalle1);
	leer(archD2, regDetalle2);
	minimo(archD1, archD2, regDetalle1, regDetalle2, min);
	while (min.nomProv <> valorAlto) do begin
		totalEnc := 0;
		totalAlfab := 0;
		aux := min.nomProv;
		while (aux = min.nomProv) do begin
			totalEnc := totalEnc + min.cantEnc;
			totalAlfab := totalAlfab + cantAlfab;
			minimo(archD1, archD2, regDetalle1, regDetalle2, min);
			end;
		while (regMaestro.nomProv <> aux) do
			read(archM, regMaestro);
		regMaestro.cantPA := regMaestro.cantPA + min.cantAlfab;
		regMaestro.totalEnc := regMaestro.totalEnc + min.cantEnc;
		seek(archM, filePos(archM)-1);
		write(archM, regMaestro);
		if (not EOF(archM)) then
			read(archM, regMaestro);
		end;
	close(archM);
	close(archD1);
	close(archD2);
end.