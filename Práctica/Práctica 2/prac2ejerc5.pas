program prac2ejerc5;
const
	valorAlto = 9999;
	sucursales = 30;
type
	cadena30 = string[30];

	producto = record
		cod: integer;
		nom: cadena30;
		desc: cadena30;
		stockDisp: integer;
		stockMin: integer;
		precio: real;
		end;

	info = record
		cod: integer;
		cantVendida: integer;
		end;
	info_texto = record
		nomProd: cadena30;
		desc: cadena30;
		stockDisp: integer;
		precio: real;
		end;
	archivo_maestro = File of producto;
	archivo_detalle = File of info;
	vector_detalles = array [1..sucursales] of archivo_detalle;
	vector_regDetalles = array [1..sucursales] of info;
procedure leer(var arch: archivo_detalle; var reg: info);
	begin
		if (not EOF(arch)) then
			read(archDetalle, reg)
			else
				reg.cod := valorAlto;
	end;
procedure inicializarVector(var v: vector_detalles);
	var
		i: integer;
	begin
		for i := 1 to sucursales do begin
			assign(v[i], 'datalle_',i,'');
			reset(v[i]);
			end;
	end;
procedure minimo(var vD: vector_detalles; var vR: vector_regDetalles; var min: info);
	var
		indiceMin, i: integer;
	begin
		min.cod := valorAlto;
		for i := 1 to sucursales do begin
			leer(vD[i], vR[i]);
			if (vR[i].cod < min.cod) then begin
				min.cod := vR[i].cod;
				indiceMin := i;
				end;
			end;
		if (min.cod <> valorAlto) then
			min := vR[indiceMin];
	end;
procedure cerrarArchivos(var vD: vector_detalles);
	var
		i: integer;
	begin
		for i := 1 to sucursales do
			close(vD[i]);
	end;
var
	archTexto: Text;
	archMaestro: archivo_maestro;
	vDetalles: vector_detalles;
	vRegDetalles: vector_regDetalles;
	min: info;
	regMaestro: producto;
	aux, stockTotal: integer;
begin
	assign(archMaestro, 'maestro');
	assign(archTexto, 'archivo_prodMenorStock')
	inicializarVector();
	reset(archMaestro);
	rewrite(archTexto);
	reset(archTexto);
	read(archMaestro, regMaestro);
	minimo(vDetalles, vRegDetalles, min);
	while (min.cod <> valorAlto) do begin
		aux := min.cod;
		stockTotal := 0;
		while (min.cod = aux) do begin
			stockTotal := stockTotal + min.cantVendida;
			minimo(vDetalles, vRegDetalles, min);
			end;
		while (regMaestro.cod <> aux) do
			read(archMaestro, regMaestro);
		regMaestro.stockDisp := regMaestro.stockDisp - stockTotal;
		seek(archMaestro, filePos(archMaestro)-1);
		write(archMaestro, regMaestro);

		if (regMaestro.stockDisp < regMaestro.stockMin) then
			writeln(archTexto, 
				regMaestro.nom,' ', 
				regMaestro.desc,' ', 
				regMaestro.stockDisp,' ',
				regm.precio:0:2);

		if (not EOF(archMaestro)) then
			read(archMaestro, regMaestro);
		end;
	close(archMaestro);
	close(archTexto);
	cerrarArchivos(vDetalles);
end.