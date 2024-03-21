program ejercicio4;
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
procedure cargarEmpleado(var e: empleado);
	begin
		write('Ingrese el apellido: ');
		readln(e.ape);
		if (e.ape <> 'fin') then begin
			write('Ingrese el nombre: ');
			readln(e.nombre);
			write('Ingrese el numero de DNI: ');
			readln(e.dni);
			if (e.dni = '') or (e.dni = '0') then
				e.dni := '00';
			write('Ingrese la edad: ');
			readln(e.edad);
			write('Ingrese el numero de empleado: ');
			readln(e.num);
		end;
	end;
procedure agregarEmpleadoAlFinal(var arch: arch_empleados; e: empleado);
	begin
		writeln('Tamanio: ',fileSize(arch));
		readln;
		seek(arch, fileSize(arch));
		write(arch, e);
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
		while (not EOF(arch)) do begin
			read(arch, e);
			if (e.nombre = nombre) or (e.ape = nombre) then
				imprimirRegistro(e);
		end;
		close(arch);
	end;
procedure actualizarEdad(var arch: arch_empleados; nombre: cadena40; edad: integer);
	var
		reg: empleado;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch, reg);
			if (reg.nombre = nombre) or (reg.ape = nombre) then begin
				seek(arch, filePos(arch)-1);
				reg.edad := edad;
				write(arch, reg);
				imprimirRegistro(reg);
			end;
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
function existeEmpleado(var arch: arch_empleados; reg: empleado): boolean;
	var
		existe: boolean;
		e: empleado;
	begin
		existe := false;
		while not (EOF(arch)) and (not existe) do begin
			read(arch, e);
			if (reg.num = e.num) then
				existe := true;
			end;
		existeEmpleado := existe;
	end;
procedure binarioATexto(var arch: arch_empleados; var archTexto: text);
	var
		reg: empleado;
	begin
		while not (EOF(arch)) do begin
			read(arch, reg);
			writeln(archTexto, filePos(arch),'. | ',reg.num,' | ', reg.ape,' | ', reg.nombre, ' | ', reg.edad, ' | ', reg.dni,' |');
			end;
	end;
procedure exportarDNIDobleCero(var arch: arch_empleados; var archTexto: text);
	var
		reg: empleado;
	begin
		while not (EOF(arch)) do begin
			read(arch, reg);
			if (reg.dni = '00') then
				writeln(archTexto, filePos(arch),'. | ',reg.num,' | ', reg.ape,' | ', reg.nombre, ' | ', reg.edad, ' | ', reg.dni,' |');
			end;
	end;
var
	archEmpleados: arch_empleados;
	archTexto: Text;
	nombre: cadena40;
	option: integer;
	num: integer;
	e: empleado;
begin
	repeat
		writeln('=============== MENU DE OPCIONES ===============');
		writeln('Ingrese (1) para: Crear un nuevo archivo de empleados.');
		writeln('Ingrese (2) para: Abrir un archivo de empleados existente.');
		writeln('Ingrese (3) para: Anadir mas empleados a un archivo existente.');
		writeln('Ingrese (4) para: Modificar edad de un empleado en un archivo existente.');
		writeln('Ingrese (5) para: Exportar empleados a un archivo a texto.');
		writeln('Ingrese (6) para: Exportar empleados con DNI 00 a un archivo de texto.');
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
					assign(archEmpleados, nombre);
					rewrite(archEmpleados);
					cargarEmpleado(e);
					while (e.ape <> 'fin') do begin
						write(archEmpleados, e);
						writeln;
						cargarEmpleado(e);
						end;
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
					writeln('EMPLEADOS ENCONTRADOS CON EL NOMBRE/APELLIDO INGRESADO');
					buscarNomApe(archEmpleados, nombre);
					writeln;
					listarEmpleados(archEmpleados);
					writeln;
					listarEmpJubilados(archEmpleados);
					writeln;
				end;
			3:	begin
					writeln('3. AGREGAR UN NUEVO EMPLEADO');
					write('Ingrese el nombre del archivo a abrir: ');
					readln(nombre);
					assign(archEmpleados, nombre);
					reset(archEmpleados);
					writeln;
					cargarEmpleado(e);
					while (e.ape <> 'fin') do begin
						if not (existeEmpleado(archEmpleados, e)) then begin
							writeln('Empleado agregado con EXITO!');
							agregarEmpleadoAlFinal(archEmpleados, e)
							end
							else
								writeln('El empleado ingresado YA EXISTE en el archivo!');
						writeln;
						cargarEmpleado(e);
						end;
					close(archEmpleados);
				end;
			4:	begin
					writeln('4. MODIFICAR LA EDAD DE UN EMPLEADO');
					write('Ingrese el nombre del archivo a abrir: ');
					readln(nombre);
					assign(archEmpleados, nombre);
					reset(archEmpleados);
					writeln;
					write('Nombre/apellido del empleado a modificar la edad: ');
					readln(nombre);
					write('Edad a actualizar: ');
					readln(num);
					actualizarEdad(archEmpleados, nombre, num);
				end;
			5:	begin
					writeln('5. EXPORTAR ARCHIVO A TEXTO');
					write('Ingrese el nombre del archivo a exportar a archivo de texto: ');
					readln(nombre);
					writeln;
					assign(archEmpleados, nombre);
					reset(archEmpleados);
					assign(archTexto, 'todos_empleados.txt');
					rewrite(archTexto);
					binarioATexto(archEmpleados, archTexto);
					writeln('Archivo "',nombre,'" exportado a texto exitosamente!');
					writeln;
					close(archEmpleados);
					close(archTexto);
				end;
			6:	begin
					writeln('6. EXPORTAR EMPLEADOS SIN DNI A TEXTO');
					write('Ingrese el nombre del archivo a exportar a archivo de texto: ');
					readln(nombre);
					writeln;
					assign(archEmpleados, nombre);
					reset(archEmpleados);
					assign(archTexto, 'faltaDNIEmpleado.txt');
					rewrite(archTexto);
					exportarDNIDobleCero(archEmpleados, archTexto);
					writeln('Archivo "',nombre,'" exportado a texto exitosamente!');
					writeln;
					close(archEmpleados);
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