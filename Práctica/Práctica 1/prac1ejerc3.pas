program ejercicio3;
type
	cadena40 = string[40];
	cadena8 = string[8];
	empleado = record
		num: integer;
		ape: cadena40;
		nombre: cadena40;
		edad: integer;
		dni: cadena8;
		end;
	arch_empleados = File of empleado;
procedure cargarEmpleado(var arch: arch_empleados);
	var
		e: empleado;
	begin
		write('Ingrese el apellido: ');
		readln(e.ape);
		while (e.ape <> 'fin') do begin
			write('Ingrese el nombre: ');
			readln(e.nombre);
			write('Ingrese el numero de DNI: ');
			readln(e.dni);
			if (e.dni = "") or (e.dni = "0") then
				e.dni = "00";
			write('Ingrese la edad: ');
			readln(e.edad);
			write('Ingrese el numero de empleado: ');
			readln(e.num);
			write(arch, e);
			writeln;
			write('Ingrese el apellido: ');
			readln(e.ape);
		end;
	end;
procedure imprimirRegistro(reg: empleado);
	begin
		writeln('| NUM Empleado: ',reg.num,' | Apellido: ',reg.ape,' | Nombre: ',reg.nombre,' | Edad: ',reg.edad, ' | DNI: ',reg.dni,' |');
	end;
procedure buscarNomApe(var arch: arch_empleados; nombre: cadena40);
	var
		e: empleado;
	begin
		reset(arch);
		writeln('EMPLEADOS ENCONTRADOS CON EL NOMBRE/APELLIDO INGRESADO');
		while (not EOF(arch)) do begin
			read(arch, e);
			if (e.nombre = nombre) or (e.ape = nombre) then
				imprimirRegistro(e);
		end;
		close(arch);
	end;
procedure listarEmpleados(var arch: arch_empleados);
	var
		e: empleado;
	begin
		reset(arch);
		writeln('================================== LISTA DE EMPLEADOS ==================================');
		while (not EOF(arch)) do begin
			write(filePos(arch)+1,'. ');
			read(arch, e);
			imprimirRegistro(e);
			end;
		close(arch);
	end;
procedure listarEmpJubilados(var arch: arch_empleados);
	var
		e: empleado;
	begin
		reset(arch);
		writeln('LISTA DE EMPLEADOS A JUBILARSE');
		while (not EOF(arch)) do begin
			read(arch, e);
			if (e.edad > 70) then
				imprimirRegistro(e);
			end;
		close(arch);
	end;	
var
	archEmpleados: arch_empleados;
	nombre: cadena40;
	option: integer;
begin
	repeat
		writeln('=============== MENU DE OPCIONES ===============');
		writeln('Ingrese (1) para: Crear un nuevo archivo de empleados.');
		writeln('Ingrese (2) para: Abrir un archivo de empleados existente.');
		writeln('Ingrese (0) para salir del programa.');
		writeln;
		write('Opcion a ingresar... ');
		readln(option);
		writeln;
		case (option) of
			1: 	begin
					writeln('1. CREAR UN NUEVO ARCHIVO.');
					write('Ingrese el nombre del archivo a crear... ');
					readln(nombre);
					assign(archEmpleados, nombre);
					rewrite(archEmpleados);
					cargarEmpleado(archEmpleados);
					close(archEmpleados);
				end;
			2:	begin
					writeln('2. ABRIR UN ARCHIVO GENERADO');
					write('Ingrese el nombre del archivo a abrir: ');
					readln(nombre);
					assign(archEmpleados, nombre);
					reset(archEmpleados);
					writeln;
					write('Ingrese un nombre o apellido a buscar: ');
					readln(nombre);
					writeln;
					buscarNomApe(archEmpleados, nombre);
					writeln;
					listarEmpleados(archEmpleados);
					writeln;
					listarEmpJubilados(archEmpleados);
					writeln;
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