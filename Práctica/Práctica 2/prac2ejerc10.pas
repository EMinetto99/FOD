program prac2ejer10;
const
	valorAlto = 9999;
	cantCat = 15;
	subRango15 = 1..15;
type
	empleado = record
		depto: integer;
		division: integer;
		numEmp: integer;
		cat: subRango15;
		cantHsExtra: integer;
		end;

	archivo_empleados = File of empleado;
	vec_catHoras = array [1 .. cantCat] of real;
procedure leer(var arch: archivo_empleados; var reg: empleado);
	begin
		if (not EOF(arch)) then
			read(arch, reg)
			else
				reg.depto := valorAlto;
	end;
procedure cargarHoras(var v: vec_catHoras; text: Text);
	var
		i, indice: integer;
		precio: real;
	begin
		for i := 1 to cantCat do begin
			read(text, precio);
			v[i] := precio;
			end;
	end;	
var
	archEmpleados: archivo_empleados;
	regEmpleados: empleado;
	vCat: vec_catHoras;
	archHoras: Text;
	deptoAct, divAct, empAct: integer;
	montoTotalDepto, horasTotalDepto, totalHorasDiv, totalMontoDiv, totalHorasEmp, importe: real;
begin
	assign(archEmpleados, 'archivo_empleados');
	assign(archHoras, 'horas_extras');
	reset(archHoras);
	cargarHoras(vCat, archHoras);
	leer(archEmpleados, regEmpleados);
	while (arch.depto <> valorAlto) do begin
		montoTotalDepto := 0;
		horasTotalDepto := 0;
		deptoAct := regEmpleados.depto;
		writeln('Departamento "',deptoAct,'"');
		while (deptoAct = regEmpleados.depto) do begin
			totalHorasDiv := 0;
			totalMontoDiv := 0;
			divAct := regEmpleados.division;
			writeln('Division ',divAct);
			while (divAct = regEmpleados.division) and (deptoAct = regEmpleados.depto) do begin
				totalHorasEmp := 0;
				importe := 0;
				empAct := regEmpleados.numEmp;
				while (empAct = regEmpleados.numEmp) and (divAct = regEmpleados.division) and (deptoAct = regEmpleados.depto) do begin
					totalHorasEmp := totalHorasEmp + regEmpleados.cantHsExtra;
					importe := importe + (regEmpleados.cantHsExtra * vCat[divAct]);
					leer(archEmpleados, regEmpleados);
					end;
				totalMontoDiv := totalMontoDiv + importe;
				totalHorasDiv := totalHorasDiv + totalHorasEmp;
				writeln('Numero de empleado: ',empAct,' | Total de horas: ',totalHorasEmp:5:1,' | Importe a cobrar: $',importe:5:2);
				end;
			montoTotalDepto := montoTotalDepto + totalMontoDiv;
			horasTotalDepto := horasTotalDepto + totalHorasDiv;
			writeln('Total horas division: ',totalHorasDiv:5:1);
			writeln('Monto total por division: $',totalMontoDiv:5:2);
			end;
		writeln('Total horas departamento: ',horasTotalDepto:5:1);
		writeln('Monto total departamento: $',montoTotalDepto:5:2);
		end;
	close(archEmpleados);
	close(archHoras);
end.