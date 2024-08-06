program ejercicio6;
type
	cadena40 = string[40];

	celular = record
		cod: integer;
		nom: cadena40;
		desc: cadena40;
		marca: cadena40;
		model: cadena40;
		precio: real;
		stock: integer;
		stock_disp: integer;
		end;
	archivo_celulares = File of celular;
{procedure crearArchivoNuevo(var archCelulares: archivo_celulares);
	begin
		rewrite(archCelulares);
		close(archCelulares);
	end;}
procedure cargarTextoAArchivo(var arch: archivo_celulares; var archText: Text);
	var
		c: celular;
	begin
		rewrite(arch);
		reset(archText);
		while not (EOF(archText)) do begin
			readln(archText, c.cod, c.precio, c.marca);
			readln(archText, c.stock_disp, c.stock, c.desc);
			readln(archText, c.nom);
			write(arch, c);
			end;
		close(arch);
		close(archText);
		writeln('Archivo cargado exitosamente!');
	end;
procedure imprimirArchivo(var arch: archivo_celulares);
	var
		reg: celular;
	begin
		reset(arch);
		while not (EOF(arch)) do begin
			read(arch, reg);
			writeln(reg.cod,' ',reg.nom,' ',reg.desc,' ',reg.marca,' ',reg.precio,' ',reg.stock,' ',reg.stock_disp);
			end;
		close(arch);
	end;
procedure celMenorAStockMinimo(var arch: archivo_celulares);
	var
		reg: celular;
	begin
		reset(arch);
		while not (EOF(arch)) do begin
			read(arch, reg);
			if (reg.stock_disp < reg.stock) then
				writeln(reg.cod,' ',reg.nom,' ',reg.desc,' ',reg.marca,' ',reg.model,' ',reg.precio,' ',reg.stock,' ',reg.stock_disp);
			end;
		close(arch);
	end;
procedure bucarCelConDescripcion(var arch: archivo_celulares; desc: cadena40);
	var
		reg: celular;
	begin
		reset(arch);
		while not (EOF(arch)) do begin
			read(arch, reg);
			if (reg.desc = desc) then
				writeln(reg.cod,' ',reg.nom,' ',reg.desc,' ',reg.marca,' ',reg.model,' ',reg.precio,' ',reg.stock,' ',reg.stock_disp);
			end;
		close(arch);
	end;
procedure exportarArchivoATexto(var arch: archivo_celulares; var archText: Text);
	var
		reg: celular;
	begin
		reset(arch);
		rewrite(archText);
		while not (EOF(arch)) do begin
			read(arch, reg);
			writeln(archText, reg.cod, reg.precio, reg.marca);
			writeln(archText, reg.stock_disp, reg.stock, reg.desc);
			writeln(archText, reg.nom);
			end;
		close(arch);
		close(archText);
	end;
procedure leerCelular(var reg: celular);
	begin
		write('Ingrese el codigo de celular (-1 para terminar): ');
		readln(reg.cod);
		if (reg.cod <> -1) then begin
			write('Ingrese el nombre del celular: ');
			readln(reg.nom);
			write('Ingrese una descripcion: ');
			readln(reg.desc);
			write('Ingrese la marca: ');
			readln(reg.marca);
			write('Ingrese el modelo: ');
			readln(reg.model);
			write('Ingrese el precio: $');
			readln(reg.precio);
			write('Ingrese el stock minimo: ');
			readln(reg.stock);
			write('Ingrese el stock disponible: ');
			readln(reg.stock_disp);
			end;
		writeln;
	end;
procedure agregarCelulares(var arch: archivo_celulares);
	var
		reg: celular;
	begin
		reset(arch);
		seek(arch, fileSize(arch));
		leerCelular(reg);
		while (reg.cod <> -1) do begin
			write(arch, reg);
			leerCelular(reg);
			end;
		writeln('Carga finalizada.');
		close(arch);
	end;
function buscarCelular(var arch: archivo_celulares; nom: cadena40): boolean;
	var
		reg: celular;
		encontre: boolean;
	begin
		encontre := false;
		reset(arch);
		while not (EOF(arch)) and not (encontre) do begin
			read(arch, reg);
			if (reg.nom = nom) then begin
				encontre := true;
				writeln('Celular encontrado!');
				write('Ingrese el stock a ingresar: ');
				readln(reg.stock);
				seek(arch, filePos(arch)-1);
				write(arch, reg);
				end;
			end;
		close(arch);
		buscarCelular := encontre;
	end;
procedure exportarSinStockATexto(var arch: archivo_celulares; var archText: Text);
	var
		reg: celular;
	begin
		while not (EOF(arch)) do begin
			read(arch, reg);
			if (reg.stock = 0) then
				writeln(archText, reg.cod,' ',reg.nom,' ',reg.desc,' ',reg.marca,' ',reg.model,' ',reg.precio,' ',reg.stock,' ',reg.stock_disp);
			end;
	end;
var
	archCelulares: archivo_celulares;
	archTextoCel, archSinStock: Text;
	nombre: cadena40;
	option: integer;
	cel: celular;
begin
	repeat
		writeln('=============== MENU DE OPCIONES ===============');
		writeln('Ingrese (1) para: Cargar un archivo en base al archivo "celulares.txt".');
		writeln('Ingrese (2) para: Listar celulares que tengan stock menor al minimo.');
		writeln('Ingrese (3) para: Listar celulares que tengan una descripcion especifica.');
		writeln('Ingrese (4) para: Exportar archivo de celulares creado a archivo de Texto.');
		writeln('Ingrese (5) para: Aniadir celulares al archivo existente.');
		writeln('Ingrese (6) para: Modificar stock de un celular.');
		writeln('Ingrese (7) para: Exportar celulares con stock 0 a archivo de Texto.');
		writeln('Ingrese (0) para salir del programa.');
		writeln;
		write('Opcion a ingresar... ');
		readln(option);
		writeln;
		case (option) of
			1: 	begin
					// El archivo "celulares.txt" ya tiene que estar creado
					write('Ingrese el nombre del archivo a crear: ');	// Creo el nuevo archivo
					readln(nombre);
					assign(archCelulares, nombre);						// Enlazo el archivo de TEXTO a una variable de ese tipo
					assign(archTextoCel, 'celulares.txt');
					cargarTextoAArchivo(archCelulares, archTextoCel);	
					imprimirArchivo(archCelulares);
				end;
			2: 	begin
					writeln('====== LISTAR CELULARES CON STOCK MINIMO ======');
					celMenorAStockMinimo(archCelulares);
					writeln('Proceso finalizado...');
					writeln;
				end;
			3: 	begin
					writeln('====== LISTAR CELULARES CON DESCRIPCION ESPECIFICA ======');
					write('Ingrese una descripcion a buscar: ');
					readln(nombre);
					bucarCelConDescripcion(archCelulares, nombre);
					writeln('Proceso finalizado...');
					writeln;
				end;
			4: 	begin
					writeln('====== EXPORTAR ARCHIVO DE CELULARES A TEXTO ======');
					write('Ingrese el nombre del archivo de celulares creado anteriormente: ');
					readln(nombre);
					assign(archCelulares, nombre);
					exportarArchivoATexto(archCelulares, archTextoCel);
					writeln('Proceso finalizado...');
					writeln;
				end;
			5: 	begin
					writeln('===== ANIADIR CELULARES A UN ARCHIVO =====');
					agregarCelulares(archCelulares);
					writeln('Proceso finalizado...');
					writeln;
				end;
			6: 	begin
				writeln('===== MODIFICAR STOCK DE UN CELULAR =====');
				write('Nombre de celular a buscar: ');
				readln(cel.nom);
				if (buscarCelular(archCelulares, cel.nom)) then
					writeln('Stock de celular modificado con exito!')
					else
						writeln('Celular no encontrado, intente con otro codigo.');
				writeln;
				end;
			7: 	begin
				writeln('===== EXPORTAR CELULARES CON CERO STOCK =====');
				assign(archSinStock, 'SinStock.txt');
				rewrite(archSinStock);
				exportarSinStockATexto(archCelulares, archSinStock);
				writeln('Proceso finalizado...');
				writeln;
				end;
			0:	begin
					write('Saliendo del programa... ');
				end;
			else
				writeln('ERROR! - Ingrese una opcion correcta.');
				end;
	until (option = 0);
	readln;
end.