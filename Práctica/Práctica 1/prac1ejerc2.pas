program ejercicio2;
type
	nom_arch = string[30];
	arch_Enteros = File of integer;
var
	nombreArchivo: nom_arch;
	archivoEnteros: arch_Enteros;
	num, cantNum, total: integer;
begin
	cantNum := 0;
	total := 0;
	write('Nombre del archivo a abrir: ');
	readln(nombreArchivo);
	assign(archivoEnteros, nombreArchivo);
	reset(archivoEnteros);
	while (not EOF(archivoEnteros)) do begin
		read(archivoEnteros, num);
		writeln(filePos(archivoEnteros),'. ',num);
		if (num < 1500) then begin
			cantNum := cantNum + 1;
			total := total + num;
			end;
		end;
	writeln('Cantidad de numeros: ',cantNum);
	writeln('Promedio de los numeros: ',(total div cantNum));
	readln;
end.