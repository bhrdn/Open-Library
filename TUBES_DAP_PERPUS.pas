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
	isLogin, isLogout, isAdmin: boolean;


label start, finish;
{/declare}


{users}
function createUsers(user, passwd : string): boolean;
begin
	
end;

function editUsers(id, passwd): boolean;
begin
	
end;

function deleteUsers(id): boolean;
begin
	
end;
{/users}

{books}
function addBooks(kodeBuku, judulBuku, jenisBuku, jumlahBuku, jumlahDipinjam): boolean;
begin
	
end;

function editBooks(kodeBuku, jumlahBuku, jumlahDipinjam): boolean;
begin
	
end;

function deleteBooks(kodeBuku): boolean;
begin
	
end;
{/books}

{menu}
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
			writeln('tambah');
		end;

		2: begin
			writeln('lihat');	
		end;

		3: begin
			isLogout := true;
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
{/menu}

procedure init;
begin
	clrscr;
	isLogin  := false;
	isLogout := false;
end;



BEGIN init; start:

if isLogin then
	menu
else login;

if isLogout then 
	goto finish;

goto start;

finish: END.
