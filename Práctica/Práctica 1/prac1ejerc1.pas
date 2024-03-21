program ejercicio1;
type
	nombre_archivo = string[30];
	archEnteros = File of integer;
var
	num: integer;
	nombre: nombre_archivo;
	archivoE : archEnteros;
begin
	write('Ingrese un nombre para el archivo: ');
	readln(nombre);
	assign(archivoE, nombre);
	rewrite(archivoE);
	write('Ingrese un numero a incorporar al archivo (Ingrese 3000 para terminar): ');
	readln(num);
	while (num <> 3000) do begin
		write(archivoE, num);
		write('Ingrese un numero a incorporar al archivo (Ingrese 3000 para terminar): ');
		readln(num);
		end;
	close(archivoE);
	reset(archivoE);
	while (not EOF(archivoE)) do begin
		write(filePos(archivoE)+1,'. ');
		read(archivoE, num);
		writeln(num);
		end;
	readln;
end.