program prac3ejer2;
type
	cadena30 = string[30];

	info_asist = record
		num: integer;
		apeNom: cadena30;
		email: cadena30;
		tel: integer;
		dni: integer;
		end;
	arch_asist = File of info_asist;
procedure leerAsistente(var reg: info_asist);
	begin
		write('Numero de asistente: ');
		readln(reg.num);
		if (reg.num <> -1) then begin
			write('Apellido y nombre: ');
			readln(reg.apeNom);
			write('e-mail: ');
			readln(reg.email);
			write('Numero de telefono: ');
			readln(reg.tel);
			write('Numero de DNI: ');
			readln(reg.dni);
			end;
	end;
procedure cargarArchivo(var arch: arch_asist);
	var
		reg: info_asist;
	begin
		reset(arch);
		leerAsistente(reg);
		writeln;
		while (reg.num <> -1) do begin
			write(arch, reg);
			leerAsistente(reg);
			writeln;
			end;
		close(arch);
	end;
procedure eliminacionLogica(var arch: arch_asist);
	var
		reg: info_asist;
		marca: cadena30;
	begin
		marca := '@';
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch, reg);
			if (reg.num < 1000) then begin
				reg.apeNom := marca + reg.apeNom;
				seek(arch, filePos(arch)-1);
				write(arch, reg);
				seek(arch, filePos(arch)+1);
				end;
			end;
		close(arch);
	end;
procedure listarAsistentes(var arch: arch_asist);
	var
		reg: info_asist;
	begin
		reset(arch);
		writeln('================================== LISTA DE ASISTENTES ==================================');
		while (not EOF(arch)) do begin
			write(filePos(arch)+1,'. ');
			read(arch, reg);
			writeln('| NUM Asistente: ',reg.num,' | Apellido y nombre: ',reg.apeNom,' | e-mail: ',reg.email,' | Telefono: ',reg.tel, ' | DNI: ',reg.dni,' |');
			end;
		close(arch);
	end;
var
	arch: arch_asist;
begin
	assign(arch, 'info_asistentes');
	rewrite(arch);
	cargarArchivo(arch);
	eliminacionLogica(arch);
	listarAsistentes(arch);
	readln;
end.