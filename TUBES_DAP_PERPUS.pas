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

	writeln; write('Apakah anda yakin akan menambahkan buku dengan kode: ', temp.kodeBuku, ' ? [y/t] '); readln(ans);
	if upcase(ans) = 'Y' then begin
		write(books, temp); close(books);
		writeln('[SUCCESS] Berhasil mendaftarkan buku dengan kode ', temp.kodeBuku); readln;
	end;

	writeln; write('Apakah anda ingin menambahkan buku lagi? [y/t] '); readln(ans);
	if upcase(ans) = 'Y' then goto start
	else isHome := true;
end;

procedure lihatBuku;
var
	i, j : integer;
	temp : schemaBooks;

begin
	writeln('anjeng');
	// booksDat;
	// if ioresult <> 0 then writeln('Data tidak ditemukan !!')
	// else begin
	// 	writeln('[MENU] LIHAT BUKU'); writeln; 

		// while not eof(books) do
		// begin
		// 	read(books, temp);

		// 	with temp do
		// 	begin
		// 		arrBooks[i].kodeBuku 		:= temp.kodeBuku;
		// 		arrBooks[i].judulBuku 		:= temp.judulBuku;
		// 		arrBooks[i].jenisBuku 		:= temp.jenisBuku;
		// 		arrBooks[i].jumlahBuku 		:= temp.jumlahBuku;
		// 		arrBooks[i].jumlahDipinjam 	:= temp.jumlahDipinjam;
		// 	end;

		// 	i := i + 1;
		// end;


		{sortingSelection}
		// for i := 2 to length(arrBooks)-1 do
		// begin
		// 	j := i;
		// 	while (j > 0) and (arrBooks[j].judulBuku < arrBooks[j-1].judulBuku) do
		// 	begin
		// 		temp 			:= arrBooks[j];
		// 		arrBooks[j] 	:= arrBooks[j-1];
		// 		arrBooks[j-1] 	:= temp;
		// 		j 				:= j -1;
		// 	end;
		// end;
		{/sortingSelection}

		{showDatas}
		// for i := 1 to length(arrBooks) do
		// begin
		// 	writeln(i, '. ', arrBooks[i].kodeBuku);
		// end;
		{/showDatas}
	// end;
end;

procedure cariBuku;
var 
	ans    		  : string;
	status, found : boolean;
	i 	   	   	  : integer;
	temp   		  : schemaBooks;
	
label start;

begin booksDat;
	start: clrscr; 
	writeln('[MENU] CARI BUKU'); writeln;
	write('Masukkan kode buku: '); readln(kodeBuku);

	status := true; found := false; i := 0;
	while (status) and (i <> filesize(books)) do
	begin
		seek(books, i);
		read(books, temp);

		if temp.kodeBuku = kodeBuku then begin
			writeln('Kode Buku: ', temp.kodeBuku);
			writeln('Judul Buku: ', temp.judulBuku);
			writeln('Jenis Buku: ', temp.jenisBuku);
			writeln('Jumlah Buku: ', temp.jumlahBuku);
			writeln('jumlah Dipinjam: ', temp.jumlahDipinjam);

			status := false;
			found  := true;
		end
		else i := i + 1;	
	end; 
	close(books);	
	
	if found then begin
		writeln; write('Apakah anda masih ingin mencari buku? [y/t] '); readln(ans);
		if upcase(ans) = 'Y' then 
			goto start
		else isHome := true;
	end
	else begin
		writeln('[FAILED] Data buku tidak ditemukan !!');
		writeln; write('Apakah anda masih ingin mencari buku? [y/t] '); readln(ans);
		if upcase(ans) = 'Y' then 
			goto start
		else isHome := true;
	end;
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
	user, passwd: string;
	temp : schemaUsers;
	i : integer;

label start;

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
