program Perpustakaan;

uses crt;

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

	schemaBorrowBooks = record
		username : string;
		kodeBuku : string;
	end;

var
	users     : file of schemaUsers;
	books     : file of schemaBooks;
	borrow    : file of schemaBorrowBooks; 

	arrUsers  : array of schemaUsers;
	arrBooks  : array of schemaBooks;
	arrBorrow : array of schemaBorrowBooks;

	{variableGlobal}
	isLogin, isLogout, isAdmin, isHome : boolean;
	sessionUser : string;
	{/variableGlobal}

	{variableBooks}
	kodeBuku, judulBuku, jenisBuku  : string;
	jumlahBuku, jumlahDipinjam 		: integer;
	{/variableBooks}

label start, finish;

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

procedure borrowDat;
begin
	assign(borrow, 'borrow.dat');
	reset(borrow);
end;
{/procedureAsip}

{functionOther}
function refreshData(tipe : string): boolean;
var
	tempUsers  : schemaUsers;
	tempBooks  : schemaBooks;
	tempBorrow : schemaBorrowBooks;
	i : integer;

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
				read(users, arrUsers[i]);
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
				read(books, arrBooks[i]);
				i := i + 1;
			end;
			close(books);
		end;

		'borrow': begin borrowDat;
			if ioresult <> 0 then begin
				writeln('[FAILED] Empty record borrow.dat');
				close(borrow); isHome := true;
			end;

			i := 0;
			setlength(arrBorrow, filesize(borrow));
			
			while not eof(borrow) do 
			begin
				read(borrow, tempBorrow);
				with tempBorrow do begin
					arrBorrow[i] := tempBorrow;
				end;
				i := i + 1;
			end;
			close(borrow);
		end;
	end;
end;
{/functionOther}

{functionUsers}
function searchUsers(user : string): integer;
var i: integer;

begin refreshData('users');
	searchUsers := -1;
	for i := 0 to length(arrUsers) do begin
		if arrUsers[i].username = user then begin
			searchUsers := i;
			break;
		end;
	end;
end;
{/functionUsers}

{functionBooks}
function searchBooks(kodeBuku : string): integer;
var
	temp : schemaBooks;
	i    : integer;

begin refreshData('books');
	searchBooks := -1;
	for i := 0 to length(arrBooks) do begin
		if arrBooks[i].kodeBuku = kodeBuku then begin
			searchBooks := i; 
			break;
		end;
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
	username, password, stat, ans : string;
	temp : schemaUsers;

begin ans := 'Y';

	while upcase(ans) = 'Y' do begin
		with temp do
		begin usersDat;
			writeln('[MENU] TAMBAH USERS'); writeln;
			write('> Username: '); readln(username);

			if filesize(users) <> 0 then begin close(users);
				if (searchUsers(username) <> -1) then begin
					writeln('[FAILED] Gagal mendaftarkan user baru (username exist)'); 
					readln; isHome := true;
				end;
			end;

			write('> Password: '); readln(password);
			write('> Status admin [y/t]: '); readln(stat);

			if upcase(stat) = 'Y' then status := 1 else status := 0;

			writeln; write('>> Apakah anda yakin akan menambahkan user baru? [y/t] '); readln(ans);
			if upcase(ans) = 'Y' then begin usersDat;
				if ioresult <> 0 then rewrite(users);
				seek(users, filesize(users)); write(users, temp); close(users);
				writeln('[SUCCESS] Berhasil mendaftarkan user baru'); readln;
			end;
		end;
		writeln; write('>> Apakah anda masih ingin menambahkan user lagi? [y/t] '); readln(ans);
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

begin booksDat;
	for i := 1 to filesize(books) do
	begin
		seek(books, i-1);
		read(books, temp);

		if temp.kodeBuku = kodeBuku then begin writeln;
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
	close(books);
end;

procedure pinjamBuku(var kodeBuku : string);
var
	tempBooks  : schemaBooks;
	tempBorrow : schemaBorrowBooks;
	i : integer;

begin booksDat;
	for i := 1 to filesize(books) do
	begin
		seek(books, i-1);
		read(books, tempBooks);

		if tempBooks.kodeBuku = kodeBuku then begin borrowDat;
			
			tempBorrow.username := sessionUser;
			tempBorrow.kodeBuku := tempBooks.kodeBuku;
			seek(borrow, filesize(borrow));
			write(borrow, tempBorrow); close(borrow);

			tempBooks.jumlahDipinjam := tempBooks.jumlahDipinjam + 1;
			seek(books, i-1); write(books, tempBooks);
			write('[SUCCESS] Berhasil meminjam buku dengan kode ', tempBooks.kodeBuku);
			readln; isHome := true;
		end; 	
	end;
	close(books);
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

	write('>> Apakah anda ingin menambahkan buku lagi? [y/t] '); readln(ans);
	if upcase(ans) = 'Y' then goto start
	else isHome := true;
end;

procedure lihatBuku;
var
	temp : schemaBooks;
	i, j : integer;

begin refreshData('books');
	if length(arrBooks) = 0 then begin
		writeln('[FAILED] Empty record books.dat'); isHome := true;
	end;

	booksDat;
	for i := 0 to length(arrBooks)-1 do begin
		for j := 0 to length(arrBooks)-1 do begin
			if arrBooks[i].jenisBuku < arrBooks[j].jenisBuku then begin
				temp := arrBooks[i];
				arrBooks[i] := arrBooks[j];
				arrBooks[j] := temp;
			end;
		end;
	end;
	close(books);

	for i := 0 to length(arrBooks)-1 do begin
		if arrBooks[i].kodeBuku <> '' then begin
			writeln(i+1, '. ', arrBooks[i].kodeBuku, ' | ', arrBooks[i].judulBuku, ' | ',  arrBooks[i].jenisBuku, ' | ',  arrBooks[i].jumlahBuku, ' | ',  arrBooks[i].jumlahDipinjam);
		end;
	end;

	writeln; writeln('Tekan (enter) untuk kembali..');
	readln;
end;

procedure cariBuku;
var
	ans, kodeBuku, stBuku : string;
	index, jmBuku 		  : integer;

begin ans := 'Y';

	while upcase(ans) = 'Y' do begin clrscr;
		write('>> Masukkan Kode Buku: '); readln(kodeBuku);
		index := searchBooks(kodeBuku);

		if index <> -1 then begin jmBuku := arrBooks[index].jumlahDipinjam + 1;

			if arrBooks[index].jumlahBuku >= jmBuku then stBuku := 'Masih bisa dipinjam'
			else stBuku := 'Stok buku habis';

			writeln('- Judul Buku: ', arrBooks[index].judulBuku);
			writeln('- Jenis Buku: ', arrBooks[index].jenisBuku);
			writeln('- Jumlah Buku: ', arrBooks[index].jumlahBuku, ' (', stBuku, ')');
			writeln('- Jumlah Dipinjam: ', arrBooks[index].jumlahDipinjam);

			if isAdmin then begin
				writeln; write('>> Apakah anda ingin mengedit data? [y/t] '); readln(ans);
				if upcase(ans) = 'Y' then begin
					editBuku(kodeBuku);
				end;
			end
			else begin
				if arrBooks[index].jumlahBuku >= jmBuku then begin
					writeln; write('>> Apakah anda ingin meminjam buku? [y/t] '); readln(ans);
					if upcase(ans) = 'Y' then begin
						pinjamBuku(kodeBuku);
					end;
				end;
			end;
		end else writeln('[FAILED] Data buku tidak ditemukan !!');

		writeln; write('>> Apakah anda masih ingin mencari buku lain? [y/t] '); readln(ans);
	end;
	isHome := true;

end;

procedure kembaliBuku;
var
	tempBorrow   : schemaBorrowBooks;
	tempBooks    : schemaBooks;
	index, i     : integer;
	idBooks, ans : string;

label finish;

begin ans := 'Y';

	while upcase(ans) = 'Y' do begin
		refreshData('books'); refreshData('borrow');

		writeln('[MENU] Mengembalikan buku'); writeln;

		if length(arrBorrow) = 0 then begin
			writeln('List buku yang anda pinjam, masih kosong !!');
			goto finish;
		end;

		for i := 0 to length(arrBorrow) do begin
			if arrBorrow[i].username = sessionUser then begin
				index := searchBooks(arrBorrow[i].kodeBuku);

				if index <> -1 then writeln(i+1, '. ', arrBooks[index].kodeBuku, ' | ', arrBooks[index].judulBuku)
				else begin
					writeln('[FAILED] Data buku tidak ditemukan !!'); isHome := true;
					break;
				end;
			end;
		end;

		writeln; write('> Masukkan kode buku: '); readln(idBooks);
		
		booksDat;
		for i := 1 to filesize(books) do
		begin
			seek(books, i-1);
			read(books, tempBooks);

			if tempBooks.kodeBuku = idBooks then begin
				tempBooks.jumlahDipinjam := tempBooks.jumlahDipinjam - 1;
				seek(books, i-1); write(books, tempBooks);
				break;
			end else begin
				writeln('[FAILED] Data buku tidak ditemukan !!'); isHome := true;
			end;
		end;

		borrowDat;
		for i := 1 to filesize(borrow) do
		begin
			seek(borrow, i-1);
			read(borrow, tempBorrow);

			if (tempBorrow.username = sessionUser) and (tempBorrow.kodeBuku = idBooks) then begin
				seek(borrow, i-1);
				truncate(borrow);
			end else begin
				writeln('[FAILED] Data buku tidak ditemukan !!'); isHome := true;
			end;
		end;

		writeln('[SUCCESS] Berhasil mengembalikan buku dengan kode ', idBooks);
		writeln; write('>> Apakah anda ingin mengembalikan buku lagi? [y/t] '); readln(ans);
	end;
	close(books); close(borrow);
	
	finish:
	writeln; writeln('Tekan (enter) untuk kembali..'); readln;
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
	writeln('Hallo ', sessionUser, ' [MENU] BOOKS');
	writeln('1. Lihat Data Buku');
	writeln('2. Cari/Pinjam Buku');
	writeln('3. Mengembalikan Buku');
	writeln('4. Keluar'); writeln;
	write('Pilih menu: '); readln(menu);

	clrscr;
	case menu of
		1: lihatBuku;
		2: cariBuku;
		3: kembaliBuku;
		4: begin
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
	index		 : integer;

label start;

begin

	while not isLogin do begin start:
		clrscr;
		writeln('[LOGIN] OPEN LIBRARY TELKOM UNIVERSITY');
		write('Username: '); readln(user); if user = '' then goto start; 
		write('Password: '); readln(passwd);

		index := searchUsers(user);
		if (index <> -1) and (arrUsers[index].password = passwd) then begin
			isLogin := true; sessionUser := arrUsers[index].username;
			if arrUsers[index].status = 1 then isAdmin := true
			else isAdmin := false;
		end else begin
			writeln('[FAILED] Login Gagal !!'); readln;
		end;
	end;
	showMenu;

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
