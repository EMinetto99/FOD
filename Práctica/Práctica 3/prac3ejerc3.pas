program prac3ejer3;
type
	cadena40 = string[40];
	novela = record
		cod: integer;
		gen: integer;
		nombre: cadena40;
		duracion: real;
		director: cadena40;
		precio: real;
		end;
	arch_novelas = File of novela;
procedure leerNovela(var n: novela);
	begin
		write('Ingrese codigo de novela (-1 para terminar): ');
		readln(n.cod);
		if (n.cod <> -1) then begin
			write('Ingrese genero de la novela: ');
			readln(n.gen);
			write('Ingrese el nombre: ');
			readln(n.nombre);
			write('Ingrese la duracion: ');
			readln(n.duracion);
			write('Ingrese el director: ');
			readln(n.director);
			write('Ingrese el precio: ');
			readln(n.precio);
		end;
	end;
procedure agregarNovela(var arch: arch_novelas; reg: novela);
	var
		indexCabecera: integer;
		regAux: novela;
	begin
		seek(arch, 0);			// Posición en cabecera
		read(arch, regAux);		// Leo cabecera
		if (regAux.cod < 0) then begin
			indexCabecera := (regAux.cod * -1);	// Transformo el indice
			seek(arch, indexCabecera);			// Me posiciono en el registro libre
			read(arch, regAux);					// Leo indice anterior en el registro eliminado
			seek(arch, filePos(arch)-1);		// Retrocedo
			write(arch, reg);				// Escribo registro nuevo
			seek(arch, 0);					// Vuelvo a la cabecera
			write(arch, regAux);			// Actualizo el indice cabecera
			end
			else begin
				seek(arch, fileSize(arch));
				write(arch, reg);
				end;
	end;
procedure modificarNovela(var arch: arch_novelas; nom: cadena40);
	var
		num: integer;
		reg: novela;
	begin
		writeln('1) Modificar genero');
		writeln('2) Modificar nombre');
		writeln('3) Modificar duracion');
		writeln('4) Modificar director');
		writeln('5) Modificar precio');
		write('Ingrese una opcion... ');
		readln(num);
		seek(arch, 1);
		read(arch, reg);
		while (not EOF(arch)) and (reg.nombre <> nom) do
			read(arch, reg);
		seek(arch, filePos(arch)-1);
		case (num) of
			1:	begin
					write('Ingrese nuevo genero: ');
					readln(reg.gen);
				end;
			2:	begin
					write('Ingrese nuevo nombre: ');
					readln(reg.nombre);
				end;
			3:	begin
					write('Ingrese nueva duracion: ');
					readln(reg.duracion);
				end;
			4:	begin
					write('Ingrese nuevo director: ');
					readln(reg.gen);
				end;
			5:	begin
					write('Ingrese nuevo precio: ');
					readln(reg.precio);
				end;
			end;
		write(arch, reg);
		writeln('Archivo modificado correctamente!');
		writeln;
	end;
procedure eliminarNovela(var arch: arch_novelas; cod: integer);
	var
		reg: novela;
		indexActual, indexCabecera: integer;
	begin
		read(arch, reg);
		while (not EOF(arch)) and (reg.cod <> cod) do
			read(arch, reg);
		indexActual := filePos(arch) - 1;
		seek(arch, 0);
		read(arch, reg);
		indexCabecera := reg.cod;
		reg.cod := (indexActual * -1);
		seek(arch, 0);
		write(arch, reg);
		seek(arch, indexActual);
		reg.cod := indexCabecera;
		write(arch, reg);
	end;
procedure binarioATexto(var arch: arch_novelas; var archTexto: Text);
	var
		reg: novela;
	begin
		while not (EOF(arch)) do begin
			read(arch, reg);
			writeln(archTexto, (filePos(arch)-1),'. | ',reg.cod,' | ', reg.gen,' | ', reg.nombre, ' | ', reg.duracion, ' | ', reg.director,' | ',reg.precio);
			end;
	end;
var
	archNovelas: arch_novelas;
	archTexto: Text;
	nombre: cadena40;
	option: integer;
	num: integer;
	nov: novela;
begin
	repeat
		writeln('=============== MENU DE OPCIONES ===============');
		writeln('Ingrese (1) para: Crear un nuevo archivo de novelas.');
		writeln('Ingrese (2) para: Dar de alta una nueva novela.');
		writeln('Ingrese (3) para: Modificar alguno de los datos de una novela.');
		writeln('Ingrese (4) para: Eliminar una novela por codigo.');
		writeln('Ingrese (5) para: Exportar archivo a texto.');
		writeln('Ingrese (0) para salir del programa.');
		writeln;
		write('Opcion a ingresar... ');
		readln(option);
		writeln;
		case (option) of
			1: 	begin
					writeln('1. CREAR UN NUEVO ARCHIVO.');
					write('Ingrese el nombre del archivo a crear: ');
					readln(nombre);
					assign(archNovelas, nombre);
					rewrite(archNovelas);
					nov.cod := 0;				// Inicializo cabecera en 0
					write(archNovelas, nov);	// Escribo el primer registro
					leerNovela(nov);
					while (nov.cod <> -1) do begin
						write(archNovelas, nov);
						writeln;
						leerNovela(nov);
						end;
					close(archNovelas);
				end;
			2:	begin
					writeln('2. DAR DE ALTA UNA NOVELA EN UN ARCHIVO EXISTENTE');
					write('Ingrese el nombre del archivo a abrir: ');
					readln(nombre);
					assign(archNovelas, nombre);
					reset(archNovelas);
					writeln;
					leerNovela(nov);
					writeln;
					agregarNovela(archNovelas, nov);
					close(archNovelas);
					writeln('Novela agregada exitosamente!');
					writeln;
				end;
			3:	begin
					writeln('3. MODIFICAR UN DATO');
					reset(archNovelas);
					write('Ingrese el nombre de la novela a modificar: ');
					readln(nombre);
					modificarNovela(archNovelas, nombre);
					close(archNovelas);
				end;
			4:	begin
					writeln('4. ELIMINAR UNA NOVELA');
					write('Ingrese el nombre del archivo a abrir: ');
					readln(nombre);
					assign(archNovelas, nombre);
					reset(archNovelas);
					writeln;
					write('Codigo de la novela a eliminar: ');
					readln(num);
					eliminarNovela(archNovelas, num);
					writeln('Novela eliminada exitosamente!');
				end;
			5:	begin
					writeln('5. EXPORTAR ARCHIVO A TEXTO');
					write('Ingrese el nombre del archivo a exportar a archivo de texto: ');
					readln(nombre);
					writeln;
					assign(archNovelas, nombre);
					reset(archNovelas);
					assign(archTexto, 'novelas.txt');
					rewrite(archTexto);
					binarioATexto(archNovelas, archTexto);
					writeln('Archivo "',nombre,'" exportado a texto exitosamente!');
					writeln;
					close(archNovelas);
					close(archTexto);
				end;
			0: 	begin
					write('Saliendo del programa... ');
				end;
			else
				writeln('ERROR! - Ingrese una opcion correcta.');
				end;
	until (option = 0);
	readln;
end.