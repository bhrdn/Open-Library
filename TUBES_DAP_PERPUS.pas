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

{procedureBooks}
procedure tambahBuku;
var ans : string;

begin
	write('Kode Buku: '); readln(kodeBuku);
	write('Judul Buku: '); readln(judulBuku);
	write('Jenis Buku: '); readln(jenisBuku);
	write('Jumlah Buku: '); readln(jumlahBuku);

	write('Apakah anda yakin akan menambahkan buku dengan kode: ', kodeBuku, ' ? [y/t]'); readln(ans);
	if (ans = 'Y') or (ans = 'y') then
		// addto files books.dat
	else isHome := true; 
end;

procedure lihatBuku;
var
	i, j : integer;
	temp : schemaBooks;

begin
	{sortingSelection}
	// for i := 2 to length(arrBooks)-1 do
	// begin
	// 	j := i;
	// 	while (j > 0) and (arrBooks[j] < arrBooks[j-1]) do
	// 	begin
	// 		temp := arrBooks[j];
	// 		arrBooks[j] := arrBooks[j-1];
	// 		arrBooks[j-1] := temp;
	// 		j := j -1;
	// 	end;
	// end;
	{/sortingSelection}

	{showDatas}
	for i := 1 to length(arrBooks) do
	begin
		// printf('%s. %s | %s | %s | %s | %s | %s', i, arrBooks[j].kodeBuku, arrBooks[j].judulBuku, arrBooks[j].jenisBuku, arrBooks[j].jumlahBuku, arrBooks[j].jumlahDipinjam);
	end;
	{/showDatas}
end;

procedure editBuku;
var 
	ans : string;
	idx : integer;

label start;

begin
	start: clrscr;

	write('Masukkan kode buku: '); readln(kodeBuku);
	idx := searchBooks(kodeBuku);

	if idx <> -1 then begin
		write('Kode Buku: '); readln(kodeBuku);
		write('Judul Buku: '); readln(judulBuku);
		write('Jenis Buku: '); readln(jenisBuku);
		write('Jumlah Buku: '); readln(jumlahBuku);

		write('Apakah anda yakin akan menambahkan buku dengan kode: ', kodeBuku, ' ? [y/t]'); readln(ans);
		if (ans = 'Y') or (ans = 'y') then
			// addto files books.dat
		else isHome := true; 
	end
	else writeln('Kode Buku Tidak Ditemukan !!');

	write('Apakah anda masih ingin mencari buku? [y/t]'); readln(ans);

	if (ans = 'Y') and (ans = 'y') then 
		goto start
	else isHome := true;
end;
{/procedureBooks}

{procedureMenu}
procedure menu;
var
	menu: integer;

begin
	clrscr;

	writeln('OPEN LIBRARY TELKOM UNIVERSITY');
	writeln('1. Tambah Data Buku');
	writeln('2. Lihat Data Buku');
	writeln('3. Edit Data Buku');
	writeln('4. Logout');
	writeln;
	write('Pilih menu: '); readln(menu);

	case menu of
		1: begin
			tambahBuku;
		end;

		2: begin
			lihatBuku;
		end;

		3: begin
			editBuku;
		end;

		4: begin
			isLogout := true;
		end
	end;

end;

procedure login;
var
	user, passwd: string;

begin
	writeln('LOGIN OPEN LIBRARY TELKOM UNIVERSITY');
	write('Username: '); readln(user);
	write('Password: '); readln(passwd);

	isLogin := true;
end;
{/procedureMenu}

procedure init;
begin
	clrscr;
	isLogin  := false;
	isLogout := false;
end;



BEGIN init; start:

if isLogin then
	menu
else if isHome then begin
	isHome := false;
	goto start;
end
else login;

if isLogout then 
	goto finish;

goto start;

finish: END.
