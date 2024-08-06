program prac2ejerc3;
const
	valorAlto = 9999;
type
	producto = record
		cod: integer;
		nomComercial: string[30];
		precio: real;
		stockAnual: integer;
		stockMin: integer;
		end;
	venta = record
		cod: integer;
		cantUnidades: integer;
		end;
	arch_detalle = File of venta;
	arch_maestro = File of producto;
procedure leer(var arch: arch_detalle; reg: venta);
	begin
		if (not EOF(arch)) then
			read(arch, reg)
			else
				reg.cod := valorAlto;
	end; 
var
	archM: arch_maestro;
	archD: arch_detalle;
	regDetalle: venta;
	regMaestro: producto;
	opcion, total, aux: integer;
	archTexto: Text;
begin
	assign(archM, 'maestro.txt');
	assign(archD, 'detalle.txt');
	assign(archTexto, 'stock_minimo.txt');
	read(opcion);
	case (opcion) of
		1: 	begin
				reset('maestro.txt');
				reset('detalle.txt');
				read(archM, regMaestro);
				leer(archD, regDetalle);
				while (regDetalle.cod <> valorAlto) do begin
					total := 0;
					aux := regMaestro.cod;
					while (aux = regMaestro.cod) do begin
						total := total + regDetalle.cantUnidades;
						leer(archD, regDetalle);
						end;
					while (regMaestro.cod <> aux) do
						read(archM, regMaestro);
					regMaestro.stockAnual := regMaestro.stockAnual - total;
					seek(filePos(archM)-1);
					write(archM, regMaestro);
					if (not EOF(archM)) do
						read(archM, regMaestro);
					end;
				close(archD);
				close(archM);
			end;
		2: 	begin
				rewrite(archTexto);
				reset(archM);
				while (not EOF(archM)) do begin
					read(archM, regMaestro);
					if (regMaestro.stockAnual < regMaestro.stockMin) then
						write(archTexto, regMaestro.cod);
					end;
			end;
		0: 	begin
				write('Cerrando el programa...');
			end;
end.