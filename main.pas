program mainTicTacToe;
uses crt,SysUtils;

type
	Board = array [1..3] of array [1..3] of char;

procedure printBoard (b : Board);
var
	i,j : integer;
begin
	writeln;
	for i := 1 to 5 do
		begin
			write('                    ');
			for j := 1 to 5 do
				begin
					if (i mod 2 = 0) then
						write('-')
					else
						if (j mod 2 = 0) then
							write('|')
						else
							write(b[(i+1) div 2][(j+1) div 2]);
				end;
			writeln;
		end;
	writeln;
end;

function convertNum (x : integer) : string;
var
	str : string;
begin
	if (x = 1) then str := '001' else
	if (x = 2) then str := '002' else
	if (x = 3) then str := '003' else
	if (x = 4) then str := '004' else
	if (x = 5) then str := '005' else
	if (x = 6) then str := '006' else
	if (x = 7) then str := '007' else
	if (x = 8) then str := '008' else
	if (x = 9) then str := '009';
	convertNum := str;
end;

function convertStr (x : string) : integer;
var
	i : integer;
begin
	if (x = 'S11') then i := 1 else
	if (x = 'S22') then i := 2 else
	if (x = 'S33') then i := 3 else
	if (x = 'S44') then i := 4 else
	if (x = 'S55') then i := 5 else
	if (x = 'S66') then i := 6 else
	if (x = 'S77') then i := 7 else
	if (x = 'S88') then i := 8 else
	if (x = 'S99') then i := 9;
	convertStr := i;
end;

function generateS2 (x : integer) : integer;
var
	i : integer;
begin
	if (x = 1) then i := 8 else
	if (x = 3) then i := 4 else
	if (x = 7) then i := 6 else
	if (x = 9) then i := 2 else
	if (x = 2) then i := 4 else
	if (x = 4) then i := 8 else
	if (x = 6) then i := 2 else
	if (x = 8) then i := 6;
	generateS2 := i;
end;

function generateL (x : integer) : integer;
var
	i : integer;
begin
	if (x = 2) then i := 3 else
	if (x = 4) then i := 1 else
	if (x = 6) then i := 9 else
	if (x = 8) then i := 7;
	generateL := i;
end;

var
	B : Board;
	S1,S2 : array [1..100] of array [1..100] of string;
	st1,st2 : array [1..100] of string;
	cst1,cst2 : integer;
	inn,sta : array [1..100] of string;
	inp1,inp2 : array [1..5] of integer;
	cstate2 : array[1..3] of string;
	f : text;
	str,cstate1,fstate,xstate,ostate : string;
	cc,inp : char;
	i,j,x,y,count,input,count1,count2 : integer;
	xx,yy : integer;
	clr,xclr,yclr, found1,found2,xfound,ofound : boolean;
	xfail,ofail : integer;
begin
	clrscr;
	
	//Membaca file dan memasukkan ke dalam matriks S1 dan S2
	assign(f,'dfa.txt');
	reset(f);
	str := '';
	y := 0;
	while (not eof(f)) do
		begin
			x := 1;
			y := y + 1;
			read(f,cc);
			while (cc <> '.') do
				begin
					if (cc <> ' ') then
						begin
							str := str + cc;
						end
					else
						begin
							S1[y][x] := str;
							S2[y][x] := str;
							str := '';
							x := x + 1;
						end;
					read(f,cc);
				end;
			if (cc = '.') then
				begin
					S1[y][x] := str;
					S2[y][x] := str;
					str := '';
				end;
			readln(f,cc);
		end;
	close(f);
	
	for i := 1 to x do
		inn[i] := S1[1][i];
	for j := 1 to y do
		sta[j] := S1[j][1];
		
	for i := 1 to 5 do
		begin
			inp1[i] := 0;
			inp2[i] := 0;
		end;
	fstate := S1[y-1][1];
	
	//state awal
	clr := false; // tidak clear
	count := 0; //   jumlah langkah = 0
	count1 := 0; //  jumlah 'X' = 0
	count2 := 0; //  jumlah 'O' = 0
	
	cstate1 := S1[2][1]; // current state 'X'
	cstate2[1] := S2[2][1]; // current state 'O'
	
	cst1 := 1;
	cst2 := 1;
	
	st1[cst1] := cstate1;
	st2[cst2] := cstate2[1];
	
	//print board awal
	for i := 1 to 3 do
		for j := 1 to 3 do
			B[i][j] := ' ';
	printBoard(B);
	
	//masukan pilihan user
	write('Will you go first? (y/n) : ');
	readln(inp);
	
	//jika input salah
	while ((inp <> 'y') and (inp <> 'n')) do
		begin
			writeln('Wrong input!!');
			write('Will you go first? (y/n) : ');
			readln(inp);
		end;
	
	if (inp = 'y') then
		begin
			//player jalan duluan
			writeln('Okay, you go first');
			
			while (not clr and (count < 9)) do
				begin
					count := count + 1;
					if (count mod 2 = 1) then
						begin
							count1 := count1 + 1;
							
							//giliran pertama
							if (count = 1) then
								begin
									writeln('Alright, but first, you must place your X in box 5');
									repeat
										begin
											write('Now, type 5 : ');
											readln(input);
											if (input <> 5) then
												writeln('Looks like i am telling you to type 5, but you did not do it');
										end
									until (input = 5);
									B[2][2] := 'X';
									inp1[count1] := 5;
									cstate1 := S1[2][6];
									
									//record state
									cst1 := cst1 + 1;
									st1[cst1] := cstate1;
								end
							else
								//bukan giliran pertama
								begin
									write('Now it is your turn. Type a number between 1-9 : ');
									readln(input);
									
									i := 0;
									j := 0;
									
									//mencari apakah kotak yang bernilai input sudah terisi
									repeat
										begin
											found1 := false;
											found2 := false;
											
											while ((i < count1) and not found1) do
												begin
													i := i + 1;
													if (inp1[i] = input) then
														found1 := true
													else
														found1 := false;
												end;
												
											while ((j < count2) and not found2) do
												begin
													j := j + 1;
													if (inp2[j] = input) then
														found2 := true
													else
														found2 := false;
												end;
												
											//jika sudah ada maka masukan input lagi
											if (found1 or found2) then
												begin
													writeln('Oops, looks like your choice was already taken');
													write('Try again. Type number between 1-9 : ');
													readln(input);
													i := 0;
													j := 0;
												end;
										end
									until (not found1 and not found2);
									
									//jika tidak ada maka langsung diisi
									if (input mod 3 = 0) then B[input div 3][3] := 'X'
									else B[(input div 3) + 1][input mod 3] := 'X';
									
									inp1[count1] := input;
									
									//menentukan current state baru untuk player
									
									//atribut untuk pencarian dalam dfa
									xx := 0;
									yy := 0;
									xclr := false;
									yclr := false;
									
									//mencari input dalam dfa
									while ((xx < x) and not xclr) do
										begin
											xx := xx + 1;
											if (inn[xx] = convertNum(input)) then xclr := true
											else xclr := false;
										end;
									
									//mencari current state dalam dfa
									while ((yy < y) and not yclr) do
										begin
											yy := yy + 1;
											if (sta[yy] = cstate1) then yclr := true
											else yclr := false;
										end;
										
									//menentukan current state yang baru sesuai input
									if (xclr and yclr) then
										cstate1 := S1[yy][xx];
									
									//record state
									cst1 := cst1 + 1;
									st1[cst1] := cstate1;
									
									//ganti current state	
									if (cstate1 = S1[y][1]) then
										begin
											xfail := 0;
											xfound := true;
											
											while ((xfail < count1)  and xfound) do
												begin
													xfail := xfail + 1;
													xstate := S1[2][1];
													
													//input pertama
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(inp1[xfail])) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = xstate)  then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														xstate := S1[yy][xx];
													
													
													//input kedua
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(input)) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = xstate)  then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														xstate := S1[yy][xx];
													
													i := 0;
													j := 0;
													found1 := false;
													found2 := false;
													
													//mencari apakah current state baru sudah ada yang mengisi di board
													
													while ((i < count1) and not found1) do
														begin
															i := i + 1;
															if (inp1[i] = convertStr(xstate)) then
																found1 := true
															else
																found1 := false;
														end;
														
													while ((j < count2) and not found2) do
														begin
															j := j + 1;
															if (inp2[j] = convertStr(xstate)) then
																found2 := true
															else
																found2 := false;
														end;
												
													if (not found1 and not found2) then
														xfound := false
													else xfound := true;
												end;
											
											if (xfound) then
												cstate1 := S1[y][1]
											else
												cstate1 := xstate;
												
											//record state
											cst1 := cst1 + 1;
											st1[cst1] := cstate1;
										end;
								end;
						end
					else
						begin
							count2 := count2 + 1;
							
							//giliran kedua
							if (count = 2) then
								begin
									writeln('Alright, now it is my turn');
									B[3][1] := 'O';
									inp2[count2] := 7;
									cstate2[1] := S2[2][8];
									
									//record state
									cst2 := cst2 + 1;
									st2[cst2] := cstate2[1];
								end
							else
							//bukan giliran kedua
								begin
									writeln('Alright, now it is my turn');
									
									//saat giliran ke-4 cpu akan selalu menutup jalan kemenangan si player
									//dengan asumsi player tidak bodoh/iseng
									//dengan memanfaatkan current state dari si player
									if (count = 4) then
										begin
											if (convertStr(cstate1) = inp2[1]) then
												begin
													B[3][3] := 'O';
													inp2[count2] := 9;
													
													//menentukan current state baru untuk cpu
													
													//atribut untuk pencarian dalam dfa
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(inp2[count2])) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = cstate2[1]) then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														cstate2[1] := S2[yy][xx];
														
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[1];
												end
											else
												begin
													if (convertStr(cstate1) mod 3 = 0) then
														B[convertStr(cstate1) div 3][3] := 'O'
													else
														B[convertStr(cstate1) div 3 + 1][convertStr(cstate1) mod 3] := 'O';
													
													inp2[count2] := convertStr(cstate1);
													
													//menentukan current state baru untuk cpu
													
													//atribut untuk pencarian dalam dfa
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = cstate2[1]) then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														cstate2[1] := S2[yy][xx];
														
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[1];
												end;
											ofail := 1;
										end
									else
									//saat giliran ke-6 atau ke-8, ada dua kemungkinan untuk cpu
									//berusaha menang atau berusaha untuk tidak kalah
										begin
											//jika current state cpu ada di dead state 
											//mungkin tidak bisa menang, tapi berusaha untuk tidak kalah
											if (cstate2[1] = S2[y][1]) then
												begin
													if (cstate1 = S1[y][1]) then
														begin
															//mencari kotak yang masih kosong
															i := 0;
															ofound := true;
															
															while ((i < 3) and ofound) do
																begin
																	i := i + 1;
																	j := 0;
																	while ((j < 3) and ofound) do
																		begin
																			j := j + 1;
																			if ((B[i][j] = 'O') or (B[i][j] = 'X')) then
																				ofound := true
																			else ofound := false;
																		end;
																end;
															
															B[i][j] := 'O';
															inp2[count2] := ((i-1) * 3) + j;
															
															//state akhir
															cstate2[1] := S2[y][1];
															cstate2[2] := S2[y][1];
															cstate2[3] := S2[y][1];
															
															//record state
															cst2 := cst2 + 1;
															st2[cst2] := cstate2[1];
														end
													else
														begin
															if (convertStr(cstate1) mod 3 = 0) then
																B[convertStr(cstate1) div 3][3] := 'O'
															else
																B[convertStr(cstate1) div 3 + 1][convertStr(cstate1) mod 3] := 'O';
															
															inp2[count2] := convertStr(cstate1);
															
															//menentukan current state baru untuk cpu
															
															//atribut untuk pencarian dalam dfa
															xx := 0;
															yy := 0;
															xclr := false;
															yclr := false;
															
															//mencari input dalam dfa
															while ((xx < x) and not xclr) do
																begin
																	xx := xx + 1;
																	if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
																	else xclr := false;
																end;
															
															//mencari current state dalam dfa
															while ((yy < y) and not yclr) do
																begin
																	yy := yy + 1;
																	if (sta[yy] = cstate2[1]) then yclr := true
																	else yclr := false;
																end;
																
															//menentukan current state yang baru sesuai input
															if (xclr and yclr) then
																cstate2[1] := S2[yy][xx];
															
															//record state
															cst2 := cst2 + 1;
															st2[cst2] := cstate2[1];
															
															//ganti current state
															//cpu mungkin memiliki lebih dari satu current state
															//yang akan menjadi kunci kemenangan bagi cpu	
															if (cstate2[1] = S2[y][1]) then
																begin
																	ofail := 0;
																	
																	while (ofail < count2) do
																		begin
																			ofail := ofail + 1;
																			ostate := S2[2][1];
																			
																			//input pertama
																			xx := 0;
																			yy := 0;
																			xclr := false;
																			yclr := false;
																			
																			//mencari input dalam dfa
																			while ((xx < x) and not xclr) do
																				begin
																					xx := xx + 1;
																					if (inn[xx] = convertNum(inp2[ofail])) then xclr := true
																					else xclr := false;
																				end;
																			
																			//mencari current state dalam dfa
																			while ((yy < y) and not yclr) do
																				begin
																					yy := yy + 1;
																					if (sta[yy] = ostate)  then yclr := true
																					else yclr := false;
																				end;
																				
																			//menentukan current state yang baru sesuai input
																			if (xclr and yclr) then
																				ostate := S2[yy][xx];
																			
																			
																			//input kedua
																			xx := 0;
																			yy := 0;
																			xclr := false;
																			yclr := false;
																			
																			//mencari input dalam dfa
																			while ((xx < x) and not xclr) do
																				begin
																					xx := xx + 1;
																					if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
																					else xclr := false;
																				end;
																			
																			//mencari current state dalam dfa
																			while ((yy < y) and not yclr) do
																				begin
																					yy := yy + 1;
																					if (sta[yy] = ostate)  then yclr := true
																					else yclr := false;
																				end;
																				
																			//menentukan current state yang baru sesuai input
																			if (xclr and yclr) then
																				ostate := S2[yy][xx];
																			
																			i := 0;
																			j := 0;
																			found1 := false;
																			found2 := false;
																			
																			//mencari apakah current state baru sudah ada yang mengisi di board
																			
																			while ((i < count1) and not found1) do
																				begin
																					i := i + 1;
																					if (inp1[i] = convertStr(ostate)) then
																						found1 := true
																					else
																						found1 := false;
																				end;
																				
																			while ((j < count2) and not found2) do
																				begin
																					j := j + 1;
																					if (inp2[j] = convertStr(ostate)) then
																						found2 := true
																					else
																						found2 := false;
																				end;
																		
																			if (not found1 and not found2) then
																				cstate2[ofail] := ostate;
																		end;
																	
																end;
														end;
													
												end
											else
											//jika current state cpu tidak di dead state 
											//mungkin bisa menang
												begin
													//memeriksa apakah jalan kemenangan cpu dihalangi oleh player
													i := 0;
													found1 := true;
													writeln(ofail);
													
													while ((i < ofail) and found1) do
														begin
															i := i + 1;
															if (convertStr(cstate2[i]) mod 3 = 0) then
																if (B[convertStr(cstate2[i]) div 3][3] = 'X') then
																	found1 := true
																else
																	found1 := false
															else
																if (B[convertStr(cstate2[i]) div 3 + 1][convertStr(cstate2[i]) mod 3] = 'X') then
																	found1 := true
																else
																	found1 := false;
														end;
													
													if (not found1) then
														begin
															//record state
															cst2 := cst2 + 1;
															st2[cst2] := cstate2[i];
															
															if (convertStr(cstate2[i]) mod 3 = 0) then
																B[convertStr(cstate2[i]) div 3][3] := 'O'
															else
																B[convertStr(cstate2[i]) div 3 + 1][convertStr(cstate2[i]) mod 3] := 'O';
																
															inp2[count2] := convertStr(cstate2[i]);
															
															//menentukan current state baru untuk cpu
															
															//atribut untuk pencarian dalam dfa
															xx := 0;
															yy := 0;
															xclr := false;
															yclr := false;
															
															//mencari input dalam dfa
															while ((xx < x) and not xclr) do
																begin
																	xx := xx + 1;
																	if (inn[xx] = convertNum(convertStr(cstate2[i]))) then xclr := true
																	else xclr := false;
																end;
															
															//mencari current state dalam dfa
															while ((yy < y) and not yclr) do
																begin
																	yy := yy + 1;
																	if (sta[yy] = cstate2[i]) then yclr := true
																	else yclr := false;
																end;
																
															//menentukan current state yang baru sesuai input
															if (xclr and yclr) then
																begin
																	cstate2[1] := S2[yy][xx];
																	cstate2[2] := S2[y][1];
																	cstate2[3] := S2[y][1];
																end;
															
															//record state
															cst2 := cst2 + 1;
															st2[cst2] := cstate2[1];
														end
													else
														begin
															inp2[count2] := convertStr(cstate1);
															
															if (inp2[count2] mod 3 = 0) then
																B[inp2[count2] div 3][3] := 'O'
															else
																B[inp2[count2] div 3 + 1][inp2[count2] mod 3] := 'O';
															
															//menentukan current state baru untuk cpu
															
															//atribut untuk pencarian dalam dfa
															xx := 0;
															yy := 0;
															xclr := false;
															yclr := false;
															
															//mencari input dalam dfa
															while ((xx < x) and not xclr) do
																begin
																	xx := xx + 1;
																	if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
																	else xclr := false;
																end;
															
															//mencari current state dalam dfa
															while ((yy < y) and not yclr) do
																begin
																	yy := yy + 1;
																	if (sta[yy] = cstate2[1]) then yclr := true
																	else yclr := false;
																end;
																
															//menentukan current state yang baru sesuai input
															if (xclr and yclr) then
																cstate2[1] := S2[yy][xx];
															
															//record state
															cst2 := cst2 + 1;
															st2[cst2] := cstate2[1];
																
															//ganti current state
															//cpu mungkin memiliki lebih dari satu current state
															//yang akan menjadi kunci kemenangan bagi cpu	
															if (cstate2[1] = S2[y][1]) then
																begin
																	ofail := 0;
																	
																	while (ofail < count2) do
																		begin
																			ofail := ofail + 1;
																			ostate := S2[2][1];
																			
																			//input pertama
																			xx := 0;
																			yy := 0;
																			xclr := false;
																			yclr := false;
																			
																			//mencari input dalam dfa
																			while ((xx < x) and not xclr) do
																				begin
																					xx := xx + 1;
																					if (inn[xx] = convertNum(inp2[ofail])) then xclr := true
																					else xclr := false;
																				end;
																			
																			//mencari current state dalam dfa
																			while ((yy < y) and not yclr) do
																				begin
																					yy := yy + 1;
																					if (sta[yy] = ostate)  then yclr := true
																					else yclr := false;
																				end;
																				
																			//menentukan current state yang baru sesuai input
																			if (xclr and yclr) then
																				ostate := S2[yy][xx];
																			
																			
																			//input kedua
																			xx := 0;
																			yy := 0;
																			xclr := false;
																			yclr := false;
																			
																			//mencari input dalam dfa
																			while ((xx < x) and not xclr) do
																				begin
																					xx := xx + 1;
																					if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
																					else xclr := false;
																				end;
																			
																			//mencari current state dalam dfa
																			while ((yy < y) and not yclr) do
																				begin
																					yy := yy + 1;
																					if (sta[yy] = ostate)  then yclr := true
																					else yclr := false;
																				end;
																				
																			//menentukan current state yang baru sesuai input
																			if (xclr and yclr) then
																				ostate := S2[yy][xx];
																			
																			i := 0;
																			j := 0;
																			found1 := false;
																			found2 := false;
																			
																			//mencari apakah current state baru sudah ada yang mengisi di board
																			
																			while ((i < count1) and not found1) do
																				begin
																					i := i + 1;
																					if (inp1[i] = convertStr(ostate)) then
																						found1 := true
																					else
																						found1 := false;
																				end;
																				
																			while ((j < count2) and not found2) do
																				begin
																					j := j + 1;
																					if (inp2[j] = convertStr(ostate)) then
																						found2 := true
																					else
																						found2 := false;
																				end;
																		
																			if (not found1 and not found2) then
																				begin
																					cstate2[ofail] := ostate;
																				end;
																		end;
																	
																end;
														end;
												end;
										end;
								end;
						end;
					
					printBoard(B);
					if (cstate1 = fstate) then
						begin
							clr := true;
							writeln('You are so good at tictactoe. Congrats on your win :))');
						end
					else
					if (cstate2[1] = fstate) then 
						begin
							clr := true;
							writeln('Unfortunately, you lose this time. But, good luck on our next matchup :))');
						end
					else
					if ((count = 9) and (cstate2[1] <> fstate) and (cstate1 <> fstate)) then
						begin
							writeln('Looks like we are tied now');
						end;
					
				end;
			write('Your state path : ');
			for i := 1 to cst1 do
				if (i <> cst1) then
					write(st1[i],'->')
				else
					writeln(st1[i]);
			write('My state path : ');
			for i := 1 to cst2 do
				if (i <> cst2) then
					write(st2[i],'->')
				else
					writeln(st2[i]);
		end
	else
	if (inp = 'n') then
		begin
			writeln('Okay, I go first');
			
			while ((count < 9) and not clr) do
				begin
					count := count + 1;
					if (count mod 2 = 0) then
						begin
							write('Now it is your turn. Type a number between 1-9 : ');
							readln(input);
									
							count1 := count1 + 1;
							i := 0;
							j := 0;
									
							//mencari apakah kotak yang bernilai input sudah terisi
							repeat
								begin
									found1 := false;
									found2 := false;
									
									while ((i < count1) and not found1) do
										begin
											i := i + 1;
											if (inp1[i] = input) then
												found1 := true
											else
												found1 := false;
										end;
										
									while ((j < count2) and not found2) do
										begin
											j := j + 1;
											if (inp2[j] = input) then
												found2 := true
											else
												found2 := false;
										end;
										
									//jika sudah ada maka masukan input lagi
									if (found1 or found2) then
										begin
											writeln('Oops, looks like your choice was already taken');
											write('Try again. Type number between 1-9 : ');
											readln(input);
											i := 0;
											j := 0;
										end;
								end
							until (not found1 and not found2);
							
							//jika tidak ada maka langsung diisi
							if (input mod 3 = 0) then B[input div 3][3] := 'X'
							else B[(input div 3) + 1][input mod 3] := 'X';
							
							inp1[count1] := input;
							
							//menentukan current state baru untuk player
							
							//atribut untuk pencarian dalam dfa
							xx := 0;
							yy := 0;
							xclr := false;
							yclr := false;
							
							//mencari input dalam dfa
							while ((xx < x) and not xclr) do
								begin
									xx := xx + 1;
									if (inn[xx] = convertNum(input)) then xclr := true
									else xclr := false;
								end;
							
							//mencari current state dalam dfa
							while ((yy < y) and not yclr) do
								begin
									yy := yy + 1;
									if (sta[yy] = cstate1) then yclr := true
									else yclr := false;
								end;
								
							//menentukan current state yang baru sesuai input
							if (xclr and yclr) then
								cstate1 := S1[yy][xx];
								
							//record state
							cst1 := cst1 + 1;
							st1[cst1] := cstate1;
							
							//ganti current state	
							if (cstate1 = S1[y][1]) then
								begin
									xfail := 0;
									xfound := true;
									
									while ((xfail < count1)  and xfound) do
										begin
											xfail := xfail + 1;
											xstate := S1[2][1];
											
											//input pertama
											xx := 0;
											yy := 0;
											xclr := false;
											yclr := false;
											
											//mencari input dalam dfa
											while ((xx < x) and not xclr) do
												begin
													xx := xx + 1;
													if (inn[xx] = convertNum(inp1[xfail])) then xclr := true
													else xclr := false;
												end;
											
											//mencari current state dalam dfa
											while ((yy < y) and not yclr) do
												begin
													yy := yy + 1;
													if (sta[yy] = xstate)  then yclr := true
													else yclr := false;
												end;
												
											//menentukan current state yang baru sesuai input
											if (xclr and yclr) then
												xstate := S1[yy][xx];
											
											
											//input kedua
											xx := 0;
											yy := 0;
											xclr := false;
											yclr := false;
											
											//mencari input dalam dfa
											while ((xx < x) and not xclr) do
												begin
													xx := xx + 1;
													if (inn[xx] = convertNum(input)) then xclr := true
													else xclr := false;
												end;
											
											//mencari current state dalam dfa
											while ((yy < y) and not yclr) do
												begin
													yy := yy + 1;
													if (sta[yy] = xstate)  then yclr := true
													else yclr := false;
												end;
												
											//menentukan current state yang baru sesuai input
											if (xclr and yclr) then
												xstate := S1[yy][xx];
											
											i := 0;
											j := 0;
											found1 := false;
											found2 := false;
											
											//mencari apakah current state baru sudah ada yang mengisi di board
										
											while ((i < count1) and not found1) do
												begin
													i := i + 1;
													if (inp1[i] = convertStr(xstate)) then
														found1 := true
													else
														found1 := false;
												end;
												
											while ((j < count2) and not found2) do
												begin
													j := j + 1;
													if (inp2[j] = convertStr(xstate)) then
														found2 := true
													else
														found2 := false;
												end;
										
											if (not found1 and not found2) then
												xfound := false
											else xfound := true;
										end;
									
									if (xfound) then
										cstate1 := S1[y][1]
									else
										cstate1 := xstate;
										
									//record state
									cst1 := cst1 + 1;
									st1[cst1] := cstate1;
								end;
						end
					else
						begin
							count2 := count2 + 1;
							
							//giliran pertama
							if (count = 1) then
								begin
									B[2][2] := 'O';
									inp2[count2] := 5;
									cstate2[1] := S2[2][6];
									
									//record state
									cst2 := cst2 + 1;
									st2[cst2] := cstate2[1];
								end
							else
							if (count = 3) then
								begin
									writeln('Alright, it is my turn');
									inp2[count2] := generateS2(inp1[1]);
									if (inp2[count2] mod 3 = 0) then
										B[inp2[count2] div 3][3] := 'O'
									else
										B[(inp2[count2] div 3) + 1][inp2[count2] mod 3] := 'O';
										
									//menentukan current state baru untuk cpu
													
									//atribut untuk pencarian dalam dfa
									xx := 0;
									yy := 0;
									xclr := false;
									yclr := false;
											
									//mencari input dalam dfa
									while ((xx < x) and not xclr) do
										begin
											xx := xx + 1;
											if (inn[xx] = convertNum(inp2[count2])) then xclr := true
											else xclr := false;
										end;
											
									//mencari current state dalam dfa
									while ((yy < y) and not yclr) do
										begin
											yy := yy + 1;
											if (sta[yy] = cstate2[1]) then yclr := true
											else yclr := false;
										end;
														
									//menentukan current state yang baru sesuai input
									if (xclr and yclr) then
										cstate2[1] := S2[yy][xx];
										
									//record state
									cst2 := cst2 + 1;
									st2[cst2] := cstate2[1];
									
									ofail := 1;
								end
							else
							if (count = 9) then
								begin
									writeln('Alright, it is my turn');
									
									if (cstate2[1] <> S2[y][1]) then
										begin
											i := 0;
											found1 := false;
											
											while ((i < count1) and not found1) do
												begin
													i := i + 1;
													if (inp1[i] = convertStr(cstate2[1])) then
														found1 := true
													else
														found1 := false;
												end;
											
											if (found1) then writeln('found1 true')
											else writeln('found1 false');
												
											//jika sudah ada maka cari kotak yang kosong
											if (found1) then
												begin
													//mencari kotak yang masih kosong
													i := 0;
													ofound := true;
													
													while ((i < 3) and ofound) do
														begin
															i := i + 1;
															j := 0;
															while ((j < 3) and ofound) do
																begin
																	j := j + 1;
																	if ((B[i][j] = 'O') or (B[i][j] = 'X')) then
																		ofound := true
																	else ofound := false;
																end;
														end;
													
													B[i][j] := 'O';
													inp2[count] := ((i-1) * 3) + j;
													
													//state akhir
													cstate2[1] := S2[y][1];
													cstate2[2] := S2[y][1];
													cstate2[3] := S2[y][1];
													
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[1]
												end
											else
												begin
													if (convertStr(cstate2[1]) mod 3 = 0) then
														B[convertStr(cstate2[1]) div 3][3] := 'O'
													else
														B[convertStr(cstate2[1]) div 3 + 1][convertStr(cstate2[1]) mod 3] := 'O';
														
													inp2[count2] := convertStr(cstate2[1]);
													
													//menentukan current state baru untuk cpu
															
													//atribut untuk pencarian dalam dfa
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(convertStr(cstate2[1]))) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = cstate2[1]) then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														cstate2[1] := S2[yy][xx];
														
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[1];
												end;
											
										end
									else
										begin
											//mencari kotak yang masih kosong
											i := 0;
											ofound := true;
											
											while ((i < 3) and ofound) do
												begin
													i := i + 1;
													j := 0;
													while ((j < 3) and ofound) do
														begin
															j := j + 1;
															if ((B[i][j] = 'O') or (B[i][j] = 'X')) then
																ofound := true
															else ofound := false;
														end;
												end;
											
											B[i][j] := 'O';
											inp2[count2] := ((i-1) * 3) + j;
											
											//state akhir
											cstate2[1] := S2[y][1];
											cstate2[2] := S2[y][1];
											cstate2[3] := S2[y][1];
											
											//record state
											cst2 := cst2 + 1;
											st2[cst2] := cstate2[1];
										end;
									
								end
							else
								begin
									//jika current state cpu ada di dead state 
									//mungkin tidak bisa menang, tapi berusaha untuk tidak kalah
									writeln('Alright, it is my turn');
									if (cstate2[1] = S2[y][1]) then
										begin
											if (convertStr(cstate1) mod 3 = 0) then
												B[convertStr(cstate1) div 3][3] := 'O'
											else
												B[convertStr(cstate1) div 3 + 1][convertStr(cstate1) mod 3] := 'O';
											
											inp2[count2] := convertStr(cstate1);
											
											//menentukan current state baru untuk cpu
											
											//atribut untuk pencarian dalam dfa
											xx := 0;
											yy := 0;
											xclr := false;
											yclr := false;
											
											//mencari input dalam dfa
											while ((xx < x) and not xclr) do
												begin
													xx := xx + 1;
													if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
													else xclr := false;
												end;
											
											//mencari current state dalam dfa
											while ((yy < y) and not yclr) do
												begin
													yy := yy + 1;
													if (sta[yy] = cstate2[1]) then yclr := true
													else yclr := false;
												end;
												
											//menentukan current state yang baru sesuai input
											if (xclr and yclr) then
												cstate2[1] := S2[yy][xx];
												
											//record state
											cst2 := cst2 + 1;
											st2[cst2] := cstate2[1];
											
											//ganti current state
											//cpu mungkin memiliki lebih dari satu current state
											//yang akan menjadi kunci kemenangan bagi cpu	
											if (cstate2[1] = S2[y][1]) then
												begin
													ofail := 0;
													
													while (ofail < count2) do
														begin
															ofail := ofail + 1;
															ostate := S2[2][1];
															
															//input pertama
															xx := 0;
															yy := 0;
															xclr := false;
															yclr := false;
															
															//mencari input dalam dfa
															while ((xx < x) and not xclr) do
																begin
																	xx := xx + 1;
																	if (inn[xx] = convertNum(inp2[ofail])) then xclr := true
																	else xclr := false;
																end;
															
															//mencari current state dalam dfa
															while ((yy < y) and not yclr) do
																begin
																	yy := yy + 1;
																	if (sta[yy] = ostate)  then yclr := true
																	else yclr := false;
																end;
																
															//menentukan current state yang baru sesuai input
															if (xclr and yclr) then
																ostate := S2[yy][xx];
															
															
															//input kedua
															xx := 0;
															yy := 0;
															xclr := false;
															yclr := false;
															
															//mencari input dalam dfa
															while ((xx < x) and not xclr) do
																begin
																	xx := xx + 1;
																	if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
																	else xclr := false;
																end;
															
															//mencari current state dalam dfa
															while ((yy < y) and not yclr) do
																begin
																	yy := yy + 1;
																	if (sta[yy] = ostate)  then yclr := true
																	else yclr := false;
																end;
																
															//menentukan current state yang baru sesuai input
															if (xclr and yclr) then
																ostate := S2[yy][xx];
															
															i := 0;
															j := 0;
															found1 := false;
															found2 := false;
															
															//mencari apakah current state baru sudah ada yang mengisi di board
															
															while ((i < count1) and not found1) do
																begin
																	i := i + 1;
																	if (inp1[i] = convertStr(ostate)) then
																		found1 := true
																	else
																		found1 := false;
																end;
																
															while ((j < count2) and not found2) do
																begin
																	j := j + 1;
																	if (inp2[j] = convertStr(ostate)) then
																		found2 := true
																	else
																		found2 := false;
																end;
														
															if (not found1 and not found2) then
																cstate2[ofail] := ostate;
														end;
													
												end;
										end
									else
									//jika current state cpu tidak di dead state 
									//mungkin bisa menang
										begin
											//memeriksa apakah jalan kemenangan cpu dihalangi oleh player
											i := 0;
											found1 := true;
											
											while ((i < ofail) and found1) do
												begin
													i := i + 1;
													if (convertStr(cstate2[i]) mod 3 = 0) then
														if (B[convertStr(cstate2[i]) div 3][3] = 'X') then
															found1 := true
														else
															found1 := false
													else
														if (B[convertStr(cstate2[i]) div 3 + 1][convertStr(cstate2[i]) mod 3] = 'X') then
															found1 := true
														else
															found1 := false;
												end;
											
											if (not found1) then
												begin
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[i];
													
													if (convertStr(cstate2[i]) mod 3 = 0) then
														B[convertStr(cstate2[i]) div 3][3] := 'O'
													else
														B[convertStr(cstate2[i]) div 3 + 1][convertStr(cstate2[i]) mod 3] := 'O';
														
													inp2[count2] := convertStr(cstate2[i]);
													
													//menentukan current state baru untuk cpu
													
													//atribut untuk pencarian dalam dfa
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(convertStr(cstate2[i]))) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = cstate2[i]) then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														begin
															cstate2[1] := S2[yy][xx];
															cstate2[2] := S2[y][1];
															cstate2[3] := S2[y][1];
														end;
													
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[1];
												end
											else
												begin
													if (cstate1 = S1[y][1]) then
														inp2[count2] := generateL(inp2[2])
													else
														inp2[count2] := convertStr(cstate1);
													
													if (inp2[count2] mod 3 = 0) then
														B[inp2[count2] div 3][3] := 'O'
													else
														B[inp2[count2] div 3 + 1][inp2[count2] mod 3] := 'O';
													
													//menentukan current state baru untuk cpu
													
													//atribut untuk pencarian dalam dfa
													xx := 0;
													yy := 0;
													xclr := false;
													yclr := false;
													
													//mencari input dalam dfa
													while ((xx < x) and not xclr) do
														begin
															xx := xx + 1;
															if (inn[xx] = convertNum(convertStr(cstate1))) then xclr := true
															else xclr := false;
														end;
													
													//mencari current state dalam dfa
													while ((yy < y) and not yclr) do
														begin
															yy := yy + 1;
															if (sta[yy] = cstate2[1]) then yclr := true
															else yclr := false;
														end;
														
													//menentukan current state yang baru sesuai input
													if (xclr and yclr) then
														cstate2[1] := S2[yy][xx];
														
													//record state
													cst2 := cst2 + 1;
													st2[cst2] := cstate2[1];
														
													//ganti current state
													//cpu mungkin memiliki lebih dari satu current state
													//yang akan menjadi kunci kemenangan bagi cpu	
													if (cstate2[1] = S2[y][1]) then
														begin
															ofail := 0;
															
															while (ofail < count2) do
																begin
																	ofail := ofail + 1;
																	ostate := S2[2][1];
																	
																	//input pertama
																	xx := 0;
																	yy := 0;
																	xclr := false;
																	yclr := false;
																	
																	//mencari input dalam dfa
																	while ((xx < x) and not xclr) do
																		begin
																			xx := xx + 1;
																			if (inn[xx] = convertNum(inp2[ofail])) then xclr := true
																			else xclr := false;
																		end;
																	
																	//mencari current state dalam dfa
																	while ((yy < y) and not yclr) do
																		begin
																			yy := yy + 1;
																			if (sta[yy] = ostate)  then yclr := true
																			else yclr := false;
																		end;
																		
																	//menentukan current state yang baru sesuai input
																	if (xclr and yclr) then
																		ostate := S2[yy][xx];
																	
																	
																	//input kedua
																	xx := 0;
																	yy := 0;
																	xclr := false;
																	yclr := false;
																	
																	//mencari input dalam dfa
																	while ((xx < x) and not xclr) do
																		begin
																			xx := xx + 1;
																			if (inn[xx] = convertNum(inp2[count2])) then xclr := true
																			else xclr := false;
																		end;
																	
																	//mencari current state dalam dfa
																	while ((yy < y) and not yclr) do
																		begin
																			yy := yy + 1;
																			if (sta[yy] = ostate)  then yclr := true
																			else yclr := false;
																		end;
																		
																	//menentukan current state yang baru sesuai input
																	if (xclr and yclr) then
																		ostate := S2[yy][xx];
																	
																	i := 0;
																	j := 0;
																	found1 := false;
																	found2 := false;
																	
																	//mencari apakah current state baru sudah ada yang mengisi di board
																	
																	while ((i < count1) and not found1) do
																		begin
																			i := i + 1;
																			if (inp1[i] = convertStr(ostate)) then
																				found1 := true
																			else
																				found1 := false;
																		end;
																		
																	while ((j < count2) and not found2) do
																		begin
																			j := j + 1;
																			if (inp2[j] = convertStr(ostate)) then
																				found2 := true
																			else
																				found2 := false;
																		end;
																
																	if (not found1 and not found2) then
																		begin
																			cstate2[ofail] := ostate;
																		end;
																end;
															
														end;
												end;
										end;
								end;
						end;
					
					printBoard(B);
					
					if (cstate1 = fstate) then
						begin
							clr := true;
							writeln('You are so good at tictactoe. Congrats on your win :))');
						end
					else
					if (cstate2[1] = fstate) then 
						begin
							clr := true;
							writeln('Unfortunately, you lose this time. But, good luck on our next matchup :))');
						end
					else
					if ((count = 9) and (cstate2[1] <> fstate) and (cstate1 <> fstate)) then
						begin
							writeln('Looks like we are tied now');
						end;
				end;
			write('Your state path : ');
			for i := 1 to cst1 do
				if (i <> cst1) then
					write(st1[i],'->')
				else
					writeln(st1[i]);
			write('My state path : ');
			for i := 1 to cst2 do
				if (i <> cst2) then
					write(st2[i],'->')
				else
					writeln(st2[i]);
		end;
	
end.
