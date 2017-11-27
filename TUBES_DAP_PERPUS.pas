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

	temp : schemaUsers;

label start, finish;
{/declare}

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

{functionOther}
function refreshData(tipe : string): boolean;
var
	tempUsers : schemaUsers;
	tempBooks : schemaBooks;
	i 		  : integer;

begin
	case tipe of
		'users': begin usersDat;
			if ioresult <> 0 then begin
				writeln('[FAILED] Empty record users.dat');
				close(users); isHome := true;
			end;

			i := 0;
			setlength(arrUsers, filesize(users));
			
			while not eof(users) do 
			begin
				read(users, tempUsers);
				with tempUsers do begin
					arrUsers[i] := tempUsers;
				end;
				i := i + 1;
			end;
			close(users);
		end;

		'books': begin booksDat;
			if ioresult <> 0 then begin
				writeln('[FAILED] Empty record books.dat');
				close(books); isHome := true;
			end;

			i := 0;
			setlength(arrBooks, filesize(books));
			
			while not eof(books) do 
			begin
				read(books, tempBooks);
				with tempBooks do begin
					arrBooks[i] := tempBooks;
				end;
				i := i + 1;
			end;
			close(books);
		end;
	end;
end;
{/functionOther}

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
function searchBooks(kodeBuku : string): integer;
var
	temp : schemaBooks;
	i    : integer;

begin refreshData('books');
	
	for i := 0 to length(arrBooks) do
	begin
		if arrBooks[i].kodeBuku = kodeBuku then begin
			searchBooks := i; break;
		end 
		else searchBooks := -1;
	end;

end;

function deleteBooks(idBooks : string): boolean;
var
	temp  	 : schemaBooks;
	found 	 : boolean;
	i, index : integer;

begin index := searchBooks(idBooks);

	if index <> -1 then begin booksDat;

		if ioresult <> 0 then deleteBooks := false;
		
		for i := index to filesize(books) do seek(books, i-1);

		seek(books, index); truncate(books); close(books);
		refreshData('books'); deleteBooks := true;

	end;
end;
{/functionBooks}

{procedureUsers}
procedure tambahUsers;
var
	temp 	  : schemaUsers;
	stat, ans : string;

begin ans := 'Y';

	while upcase(ans) = 'Y' do begin
		usersDat;
		if ioresult <> 0 then rewrite(users);
		seek(users, filesize(users));

		with temp do
		begin
			writeln('[MENU] TAMBAH USERS'); writeln;
			write('> Username: '); readln(username);
			write('> Password: '); readln(password);
			write('> Status admin [y/t]: '); readln(stat);

			if upcase(stat) = 'Y' then status := 1
			else status := 0;
		end;

		writeln; write('>> Apakah anda yakin akan menambahkan user baru? [y/t] '); readln(ans);
		if upcase(ans) = 'Y' then begin
			write(users, temp); close(users);
			writeln('[SUCCESS] Berhasil mendaftarkan user baru'); readln;
		end;

		writeln; write('>> Apakah anda ingin menambahkan user lagi? [y/t] '); readln(ans);
	end;
	isHome := true;

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

// begin refreshData('books');
// 	if length(arrBooks) <> 0 then begin
// 		{todo: sorting}
// 		for i := 0 to length(arrBooks) do
// 		begin
// 			if arrBooks[i].kodeBuku <> '' then begin
// 				writeln(i+1, '. ', arrBooks[i].kodeBuku, ' | ', arrBooks[i].judulBuku, ' | ',  arrBooks[i].jenisBuku, ' | ',  arrBooks[i].jumlahBuku, ' | ',  arrBooks[i].jumlahDipinjam);
// 			end;
// 		end;
// 	end
// 	else begin
// 		writeln('[FAILED] Empty record books.dat'); isHome := false;
// 	end;

// 	readln;
// end;

begin booksDat;

	i := 1;	
	while not eof(books) do begin
		
		read(books, temp);
		with temp do begin
			writeln(i, '. ', temp.kodeBuku, ' | ', temp.judulBuku, ' | ',  temp.jenisBuku, ' | ',  temp.jumlahBuku, ' | ',  temp.jumlahDipinjam);
		end;
		i := i + 1;

	end;
	close(books); readln;

end;

procedure cariBuku;
var
	ans, kodeBuku : string;
	index 		  : integer;

begin ans := 'Y';

	while upcase(ans) = 'Y' do begin clrscr;
		write('>> Masukkan Kode Buku: '); readln(kodeBuku);
		index := searchBooks(kodeBuku);

		if index <> -1 then begin
			writeln('- Judul Buku: ', arrBooks[index].judulBuku);
			writeln('- Jenis Buku: ', arrBooks[index].jenisBuku);
			writeln('- Jumlah Buku: ', arrBooks[index].jumlahBuku);
			writeln('- Jumlah Dipinjam: ', arrBooks[index].jumlahDipinjam);

			if isAdmin then begin
				writeln; write('>> Apakah anda ingin mengedit data? [y/t] '); readln(ans);
				if upcase(ans) = 'Y' then begin
					editBuku(kodeBuku);
				end;
			end;
		end else writeln('[FAILED] Data buku tidak ditemukan !!');

		writeln; write('>> Apakah anda masih ingin mencari buku lain? [y/t] '); readln(ans);
	end;
	isHome := true;

end;

procedure hapusBuku;
var
	ans, kodeBuku : string;
	index 		  : integer;

begin ans := 'Y';

	while upcase(ans) = 'Y' do begin clrscr;
		write('>> Masukkan Kode Buku: '); readln(kodeBuku);
		index := searchBooks(kodeBuku);

		if index <> -1 then begin
			writeln('- Judul Buku: ', arrBooks[index].judulBuku);
			writeln('- Jenis Buku: ', arrBooks[index].jenisBuku);
			writeln('- Jumlah Buku: ', arrBooks[index].jumlahBuku);
			writeln('- Jumlah Dipinjam: ', arrBooks[index].jumlahDipinjam);

			if isAdmin then begin
				writeln; write('>> Apakah anda ingin hapus data? [y/t] '); readln(ans);
				if upcase(ans) = 'Y' then begin
					if deleteBooks(kodeBuku) then writeln('[SUCCESS] Berhasil menghapus data buku !!')
					else writeln('[FAILED] Gagal menghapus data buku !!');
				end;
			end;
		end else writeln('[FAILED] Data buku tidak ditemukan !!');

		writeln; write('>> Apakah anda masih ingin menghapus buku lain? [y/t] '); readln(ans);
	end;
	isHome := true;

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
	i 			 : integer;

begin refreshData('users');
	
	while not isLogin do begin
		clrscr;
		writeln('[LOGIN] OPEN LIBRARY TELKOM UNIVERSITY');
		write('Username: '); readln(user);
		write('Password: '); readln(passwd);

		for i := 0 to length(arrUsers) do
		begin
			if (arrUsers[i].username = user) and (arrUsers[i].password = passwd) then begin
				isLogin := true;
				if arrUsers[i].status = 1 then isAdmin := true
				else isAdmin := false;
				break;
			end
			else begin
				writeln('[FAILED] Login Gagal !!');
				readln; break;
			end;
		end; 
	end;
	showMenu;

end;
{/procedureOther}

BEGIN init; start:

usersDat;

while not eof(users) do begin
	read(users, temp);
	with temp do begin
		writeln(temp.username, temp.password, temp.status);
	end;
end;
close(users);

readln;

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
