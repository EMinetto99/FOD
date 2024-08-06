program ejercicio7;
type
	cadena40 = string[40];

	novela = record
		cod: integer;
		nom: cadena40;
		gen: cadena40;
		precio: real;
		end;
	archivo_novela = File of novela;
procedure cargarTextoAArchivo(var arch: archivo_novela; var archText: Text);
	var
		n: novela;
	begin
		rewrite(arch);
		reset(archText);
		while not (EOF(archText)) do begin
			readln(archText, n.cod, n.precio, n.gen);
			readln(archText, n.nom);
			write(arch, n);
			end;
		close(arch);
		close(archText);
		writeln('Archivo cargado exitosamente!');
	end;
procedure imprimirArchivo(var arch: archivo_novela);
	var
		reg: novela;
	begin
		reset(arch);
		while not (EOF(arch)) do begin
			read(arch, reg);
			writeln(reg.cod,' ',reg.nom,' ',reg.gen,' ',reg.precio);
			end;
		close(arch);
	end;
procedure leerNovela(var reg: novela);
	begin
		write('Ingrese el codigo de la novela: ');
		readln(reg.cod);
		write('Nombre de la novela: ');
		readln(reg.nom);
		write('Ingrese el genero de la novela: ');
		readln(reg.gen);
		write('Ingrese el precio: $');
		readln(reg.precio);
		writeln;
	end;
procedure agregarNovela(var arch: archivo_novela; reg: novela);
	begin
		reset(arch);
		seek(arch, fileSize(arch));
		write(arch, reg);
		writeln('Novela añadida con exito!');
		close(arch);
	end;
function actualizarNovela(var arch: archivo_novela; cod: integer): boolean;
	var
		reg: novela;
		encontre: boolean;
	begin
		encontre := false;
		reset(arch);
		while not (EOF(arch)) and not (encontre) do begin
			read(arch, reg);
			if (reg.cod = cod) then begin
				encontre := true;
				write('Novela con codigo "',cod,'" encontrada!');
				leerNovela(reg);
				seek(arch, filePos(arch)-1);
				write(arch, reg);
				end;
			end;
		close(arch);
		actualizarNovela := encontre;
	end;
var
	archNovela: archivo_novela;
	archTextoNovel: Text;
	nombre: cadena40;
	option, num: integer;
	option_2: char;
	regNov: novela;
begin
	repeat
		writeln('=============== MENU DE OPCIONES ===============');
		writeln('Ingrese (1) para: Cargar un archivo en base al archivo "novelas.txt".');
		writeln('Ingrese (2) para: Agregar o actualizar novela.');
		writeln('Ingrese (0) para salir del programa.');
		writeln;
		write('Opcion a ingresar... ');
		readln(option);
		writeln;
		case (option) of
			1: 	begin
					//El archivo de texto ya debería estar cargado
					write('Ingrese el nombre del archivo a crear: ');
					readln(nombre);
					assign(archNovela, nombre);
					assign(archTextoNovel, 'novelas.txt');
					cargarTextoAArchivo(archNovela, archTextoNovel);
					imprimirArchivo(archNovela);
				end;
			2: 	begin
					writeln('====== AGREGAR / ACTUALIZAR NOVELA ======');
					repeat
						writeln('Ingrese (a) para: Agregar una novela.');
						writeln('Ingrese (b) para: Actualizar una novela existente.');
						writeln('Ingrese (c) para: Volver al menu principal.');
						writeln;
						write('Opcion a ingresar... ');
						readln(option_2);
						writeln;
						case (option_2) of
							'a':	begin
										leerNovela(regNov);
										agregarNovela(archNovela, regNov);
										writeln('Proceso finalizado...');
										writeln;
									end;
							'b':	begin
										write('Codigo de novela a actualizar: ');
										readln(num);
										if (actualizarNovela(archNovela, num)) then
											writeln('Novela actualizada con exito!')
											else
												writeln('Novela no encontrada, intente con otro codigo.');
										writeln('Proceso finalizado...');
										writeln;
									end;
							'c':	begin
										write('Saliendo al menu... ');
									end;
							else
								writeln('ERROR! - Ingrese una opcion correcta.');
								end;
					until (option_2 = 'c');
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