program Perpustakaan;

uses crt;

{declare}
type 
	schemaUsers = record
		username : string;
		password : string;
		status   : integer;
	end;

	schemaBooks = record
		kodeBuku 	   : string;
		judulBuku 	   : string;
		jenisBuku 	   : string;
		jumlahBuku 	   : integer;
		jumlahDipinjam : integer;
	end;

var
	users : file of schemaUsers;
	books : file of schemaBooks;
	arrUsers : array of schemaUsers;
	arrBooks : array of schemaBooks;
	isLogin, isLogout, isAdmin, isHome : boolean;

	{variableBooks}
	kodeBuku, judulBuku, jenisBuku  : string;
	jumlahBuku, jumlahDipinjam 		: integer;
	{/variableBooks}

	{variableUsers}
	username, password : string;
	{/variableUsers}

label start, finish;
{/declare}


{functionUsers}
function createUsers(user, passwd : string): boolean;
begin
	
end;

function editUsers(id, passwd : string): boolean;
begin
	
end;

function deleteUsers(id : string): boolean;
begin
	
end;
{/functionUsers}

{functionBooks}
function addBooks(kodeBuku, judulBuku, jenisBuku, jumlahBuku, jumlahDipinjam : string): boolean;
begin
	
end;

function editBooks(kodeBuku, jumlahBuku, jumlahDipinjam : string): boolean;
begin
	
end;

function deleteBooks(kodeBuku : string): boolean;
begin
	
end;

function searchBooks(kodeBuku : string): integer;
begin
	// search kodeBuku and return index of array (integer)
end;
{/functionBooks}

{procedureAsip}
procedure usersDat;
begin
	assign(users, 'users.dat');
	reset(users);
end;

procedure booksDat;
begin
	assign(books, 'books.dat');
	reset(books);
end;
{/procedureAsip}

{procedureUsers}
procedure tambahUsers;
begin
	
end;
{/procedureUsers}

{procedureBooks}
procedure editBuku(var kodeBuku : string);
var
	temp : schemaBooks;
	ans  : string;
	i 	 : integer;

begin

	for i := 1 to filesize(books) do
	begin
		seek(books, i-1);
		read(books, temp);

		if temp.kodeBuku = kodeBuku then begin clrscr;
			writeln('>> Kode Buku: ', temp.kodeBuku);
			write('> Judul Buku: '); readln(temp.judulBuku);
			write('> Jenis Buku: '); readln(temp.jenisBuku);
			write('> Jumlah Buku: '); readln(temp.jumlahBuku);
			write('> Jumlah Dipinjam: '); readln(temp.jumlahDipinjam);

			writeln; write('>> Apakah anda yakin akan mengedit buku dengan kode: ', temp.kodeBuku, ' ? [y/t] '); readln(ans);
			if upcase(ans) = 'Y' then begin
				seek(books, i-1); write(books, temp);
				writeln('[SUCCESS] Berhasil mengedit buku dengan kode ', temp.kodeBuku);
				readln; isHome := true;
			end;
		end; 	
	end;
end;

procedure tambahBuku;
var 
	ans : string;
	temp : schemaBooks;

label start;

begin start:
	clrscr;

	booksDat;
	if ioresult <> 0 then rewrite(books);
	seek(books, filesize(books));

	with temp do
	begin
		writeln('[MENU] TAMBAH BUKU'); writeln;
		write('> Kode Buku: '); readln(kodeBuku);
		write('> Judul Buku: '); readln(judulBuku);
		write('> Jenis Buku: '); readln(jenisBuku);
		write('> Jumlah Buku: '); readln(jumlahBuku);
		jumlahDipinjam := 0;
	end;

	writeln; write('>> Apakah anda yakin akan menambahkan buku dengan kode: ', temp.kodeBuku, ' ? [y/t] '); readln(ans);
	if upcase(ans) = 'Y' then begin
		write(books, temp); close(books);
		writeln('[SUCCESS] Berhasil mendaftarkan buku dengan kode ', temp.kodeBuku); readln;
	end;

	writeln; write('>> Apakah anda ingin menambahkan buku lagi? [y/t] '); readln(ans);
	if upcase(ans) = 'Y' then goto start
	else isHome := true;
end;

procedure lihatBuku;
var
	temp : schemaBooks;
	i, j : integer;

begin booksDat;

	if ioresult <> 0 then begin
		writeln('[FAILED] Empty record books.dat');
		close(books); isHome := true;
	end;

	i := 0;
	setlength(arrBooks, filesize(books)-1);
	
	while not eof(books) do 
	begin
		read(books, temp);
		with temp do begin
			arrBooks[i] := temp;
		end;
		i := i + 1;
	end;
	close(books);

	{for i := length(arrBooks) to 2 do
	begin
		for j := 2 to i do
		begin
			if arrBooks[j-1].kodeBuku > arrBooks[j].kodeBuku then begin
				temp 		  := arrBooks[j-1];
				arrBooks[j-1] := arrBooks[j];
				arrBooks[j]   := temp;
			end;
		end;
	end;}

	for i := 0 to length(arrBooks) do
	begin
		writeln(i, '. ', arrBooks[i].kodeBuku, ' | ', arrBooks[i].judulBuku, ' | ',  arrBooks[i].jenisBuku, ' | ',  arrBooks[i].jumlahBuku, ' | ',  arrBooks[i].jumlahDipinjam);
	end;

	readln;
end;

procedure cariBuku;
var 
	temp  	 	 : schemaBooks;
	found 	 	 : boolean;
	ans, idBooks : string;
	i 			 : integer;

begin

	ans := 'Y';
	while upcase(ans) = 'Y' do
	begin booksDat;
		clrscr; found := false;
		writeln('[MENU] CARI BUKU'); writeln;
		write('> Masukkan kode buku: '); readln(idBooks);
		
		for i := 1 to filesize(books) do
		begin
			seek(books, i-1);
			read(books, temp);

			if temp.kodeBuku = idBooks then begin
				writeln('- Judul Buku: ', temp.judulBuku);
				writeln('- Jenis Buku: ', temp.jenisBuku);
				writeln('- Jumlah Buku: ', temp.jumlahBuku);
				writeln('- Jumlah Dipinjam: ', temp.jumlahDipinjam);

				found := true;
			end;
		end;

		if not found then writeln('[FAILED] Data buku tidak ditemukan !!');

		if isAdmin and found then begin
			writeln; write('>> Apakah anda ingin mengedit data? [y/t] '); readln(ans);
			if upcase(ans) = 'Y' then begin
				editBuku(idBooks);
			end;
		end;
		close(books); 

		writeln; write('>> Apakah anda masih ingin mencari buku lain? [y/t] '); readln(ans);
	end;
	isHome := true;

end;

procedure hapusBuku;
begin
	
end;
{/procedureBooks}

{procedureMenu}
procedure menuDefault;
var
	menu: integer;

begin
	clrscr;
	writeln('[MENU] BOOKS');
	writeln('1. Lihat Data Buku');
	writeln('2. Cari Data Buku');
	writeln('3. Keluar'); writeln;
	write('Pilih menu: '); readln(menu);

	clrscr;
	case menu of
		1: lihatBuku;
		2: cariBuku;
		3: begin
			isLogout := true;
		end;
	end;
end;

procedure menuAdmin;
var menu : integer;

begin
	clrscr;
	writeln('[MENU] BOOKS');
	writeln('1. Lihat Data Buku');
	writeln('2. Cari/Edit Data Buku');
	writeln('3. Tambah Data Buku');
	writeln('4. Hapus Data Buku');
	writeln;

	writeln('[MENU] EXTRA');
	writeln('5. Tambah Users');
	writeln('6. Keluar'); writeln;
	write('Pilih menu: '); readln(menu);

	clrscr;
	case menu of
		1: lihatBuku;
		2: cariBuku;
		3: tambahBuku;
		4: hapusBuku;
		5: tambahUsers;
		6: begin
			isLogout := true;
		end;
	end;
end;

procedure showMenu;
begin
	if isAdmin then	menuAdmin
	else menuDefault;
end;
{/procedureMenu}

{procedureOther}
procedure init;
begin
	clrscr;
	isLogin  := false;
	isLogout := false;
	isAdmin  := false;
	isHome 	 := false;
end;

procedure login;
var
	user, passwd : string;
	temp 		 : schemaUsers;
	i 			 : integer;

begin usersDat;
	
	while not isLogin do begin
		clrscr;
		writeln('[LOGIN] OPEN LIBRARY TELKOM UNIVERSITY');
		write('Username: '); readln(user);
		write('Password: '); readln(passwd);

		for i := 1 to filesize(users) do
		begin
			seek(users, i-1);
			read(users, temp);

			if (temp.username = user) and (temp.password = passwd) then begin
				isLogin := true;
				if temp.status = 1 then isAdmin := true
				else isAdmin := false;
			end
			else begin
				writeln('[FAILED] Login Gagal !!'); readln;
			end;
		end; 
	end;
	close(users); showMenu;

end;
{/procedureOther}

BEGIN init; start:

if isLogin then
	showMenu
else if isHome then begin
	isHome := false;
	goto start;
end
else login;

if isLogout then 
	goto finish;

goto start;

finish: END.
