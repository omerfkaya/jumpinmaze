program JumpInMaze;
uses crt, sysutils, dos;

var
   run , lang ,now, enter, dif ,oldm,index,counter,wordlen,mapx,mapy,cheat:integer;{lang=1 => Türkçe , lang=2 => English | dif => Zorluk , Difficulty | wordlen => Kelime Uzunluðu, Word Length |cheat => Hile}
   point: array[1..20] of char;
   i,j,m,k:integer;{Döngü deðiþkenleri}
   {Zaman ve Score Deðiþkenleri Baþlangýcý, Time and Score Variable Start}
   time1,time2,tmpint: double;
   hour,minute,second,msecond:word;
   score:double;
   {Zaman ve Score Deðiþkenleri Bitiþi, Time and Score Variable End}
   {Scoreboard Deðiþkenleri Baþlangýcý, Scoreboard Variables Start}
   name,tmpstr:string;
   scorename: array[1..10] of string;
   scorepoint: array[1..10] of double;
   {Scoreboard Deðiþkenleri Bitiþi, Scoreboard Variables End}
   language: array[1..2,1..100] of string;{Dil Bilgileri,Language Inf}
   {Zýplamalý Oyun Baþlangýç, Jumpgame Start}
   moves: array[1..10] of integer;
   starmap: array[1..10,1..12] of string;
   map: array[1..10,1..12] of integer;
   {Zýplamalý Oyun Bitiþ, Jumpgame End}
   {Tahmin Oyunu Baþlangýç, Guess Game Start}
   randomchar: array[1..20] of char;
   str:string;
   guess:string;
   {Tahmin Oyunu Bitiþ, Guess Game End}

{Tuþ Okuyucu Baþlangýcý, Button Reader Start}
function arrow():integer;
var
   ch:char;
begin
   ch:=readkey;
   if ch=#0 then
   begin
      case readkey of
        #72 : arrow:=8;{Yukarý Yön Tuþu, Up Arrow}
        #75 : arrow:=4;{Sol Yön Tuþu, Left Arrow}
        #77 : arrow:=6;{Sað Yön Tuþu, Right Arrow}
        #80 : arrow:=2;{Aþaðý Yön Tuþu, Down Arrow}
      end;
   end
   else if ch=#27 then {Esc Tuþu, Esc Button}
      arrow:=3
   else if ch=#13 then {Enter Tuþu, Enter Button}
      arrow:=0;
end;
{Tuþ Okuyucu Bitiþi, Button Reader End}

{Zamanlayýcý Baþlangýcý, Timer Start}
procedure TimerStart;
begin
  GetTime(hour, minute, second, msecond);
end;

function TimerStop():longint;
var c_hours: word;
    c_minutes: word;
    c_seconds: word;
    c_msecond: word;

begin
  GetTime(c_hours, c_minutes, c_seconds, c_msecond);
  timerstop := (c_seconds - second) + ((c_minutes - minute) * 60) + ((c_hours - hour) *3600);
end;
{Zamanlayýcý Bitiþi, Timer End}

{Ýþaretleyici Oynatýcý Baþlangýcý, Pointer Mover Start}
procedure pointer(max,move:integer);
begin
   if((move=2) and (now<max)) then
   begin
      point[now]:=' ';
      point[now+1]:='>';
      now:=now+1;
   end;
   if((move=8) and (now>1)) then
   begin
      point[now]:=' ';
      point[now-1]:='>';
      now:=now-1;
   end;
end;
{Ýþaretleyici Oynatýcý Bitiþi, Pointer Mover End}

{Ýþaretleyici Sýfýrlama Baþlangýcý, Pointer Reset Start}
procedure pointerreset();
begin
  point[1]:='>';
  point[2]:=' ';
  point[3]:=' ';
  point[4]:=' ';
  point[5]:=' ';
  point[6]:=' ';
  point[7]:=' ';
  point[8]:=' ';
  point[9]:=' ';
  point[10]:=' ';
  now:=1;
end;
{Ýþaretleyici Sýfýrlama Bitiþi, Pointer Reset End}

{Oyun Ýsmi Yazýcý Baþlangýcý, Game Name Writer Start}
procedure gamename();
begin
  writeln('-----JumpInMaze-----');
  writeln();
end;
{Oyun Ýsmi Yazýcý Bitiþi, Game Name Writer End}

{Ana Program Baþlangýcý, Main Start}
begin
   {Dil Baþlangýcý, Language Start}
      language[1,1]:=' Oyuna Basla';
      language[2,1]:=' Start Game';
      language[1,2]:=' Ayarlar';
      language[2,2]:=' Settings';
      language[1,3]:=' Puan Tablosu';
      language[2,3]:=' Score Table';
      language[1,4]:=' Cikis';
      language[2,4]:=' Exit';
      language[1,5]:=' Taslarin Orani   :';
      language[2,5]:=' Stone Percent:';
      language[1,6]:=' Bosluklarin Orani:';
      language[2,6]:=' Space Percent:';
      language[1,7]:=' Dil: [tr]';
      language[2,7]:=' Language: [en]';
      language[1,8]:=' Harita Genisligi (X) : ';
      language[2,8]:=' Map Width  (X) : ';
      language[1,9]:=' Harita Uzunlugu  (Y) : ';
      language[2,9]:=' Map Height (Y) : ';
      language[1,10]:=' Kelime Uzunlugu:';
      language[2,10]:=' Word Length: ';
      language[1,11]:=' Ust Menu';
      language[2,11]:=' Go Back';
      language[1,12]:=' Ezberlediginde enter a bas.';
      language[2,12]:=' When you memorize it, press enter.';
      language[1,13]:=' Ezberlediginiz karakter dizisini giriniz: ';
      language[2,13]:=' Enter character array which you memorize: ';
      language[1,14]:=' Ilk 10 a girdiniz.';
      language[2,14]:=' You are in Top 10.';
      language[1,15]:=' Adinizi giriniz: ';
      language[2,15]:=' Enter your name: ';
      language[1,16]:=' Puan tablosuna kaydedildiniz.';
      language[2,16]:=' You saved in score table ';
      language[1,17]:=' Hile';
      language[2,17]:=' Cheat';
      language[1,18]:=' Kapali';
      language[2,18]:=' is Off';
      language[1,19]:=' Acik';
      language[2,19]:=' is On';
   {Dil Bitiþi, Language End}
   {Default Settings Start , Varsayýlan Ayarlar Baþlangýcý}
      Randomize;
      cursoroff;{cursor kapama}
      str:='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'; {Rasgele karakter çekilen dizi}
      lang:=1;
      run:=0;
      dif:=70;
      mapx:=10;
      cheat:=0;
      mapy:=12;
      pointerreset();
      for i:=1 to 10 do
         scorepoint[i]:=0;
      for i:=1 to 10 do
         scorename[i]:='';
      wordlen:=20;
   {Default Settings End , Varsayýlan Ayarlar Bitiþi}
   while(run=0) do
   begin
      pointerreset();
      {Anamenü Baþlangýç, Mainmenu Start}
      repeat
         clrscr;
         gamename();
         writeln(' -',point[1],language[lang,1]);
         writeln(' -',point[2],language[lang,2]);
         writeln(' -',point[3],language[lang,3]);
         writeln(' -',point[4],language[lang,4]);
         enter:=arrow();
         if(enter=3) then
         begin
            enter:=0;
            now:=4;
         end;
         pointer(4,enter);
      until((enter=0));
      {Anamenü Bitiþ, Mainmenu End}

      {Çýkýþ Baþlangýcý, Exit Start}
      if (now=4) then
      begin
         run:=1;
      end;
      {Çýkýþ Bitiþ, Exit End}

      {Puan Tablosu Baþlangýcý, Score Board Start}
      if (now=3) then
      begin
      repeat
         clrscr;
         gamename();
         writeln(language[lang,3]);
         writeln();
         for i:=1 to 10 do
         begin
            if (scorename[i]='') then
               writeln(' ',i,') ....')
            else
               writeln(' ',i,') ',scorename[i],' [',scorepoint[i]:0:0,']');
         end;
         writeln();
         writeln(' ->',language[lang,11]);
         enter:=arrow();
      until((enter=0)or(enter=3));
      end;
      {Puan Tablosu Bitiþi, Score Board End}

      {Ayarlar Baþlangýcý, Settings Start}
      if (now=2) then
      begin
         pointerreset();
         repeat
            clrscr;
            gamename();
            writeln(language[lang,2]);
            writeln();
            write(' -',point[1],language[lang,5],' [');
            for i:=1 to (dif DIV 10) do
               write('|');
            for i:=1 to (10-(dif DIV 10)) do
               write('-');
            write('] ','%',dif);
            writeln();
            write(' -',point[2],language[lang,6],' [');
            for i:=1 to (10-(dif DIV 10)) do
               write('|');
            for i:=1 to (dif DIV 10) do
               write('-');
            write('] ','%',(100-dif));
            writeln();
            writeln(' -',point[3],language[lang,7]);
            writeln(' -',point[4],language[lang,8],mapx);
            writeln(' -',point[5],language[lang,9],mapy);
            writeln(' -',point[6],language[lang,10],wordlen);
            if(cheat=0) then
            begin
               writeln(' -',point[7],language[lang,17],language[lang,18]);
            end
            else if(cheat=1) then
            begin
               writeln(' -',point[7],language[lang,17],language[lang,19]);
            end;
            writeln(' -',point[8],language[lang,11]);
            enter:=arrow();

            {Saða Basma Baþlangýcý , Press Right Start}
            if(enter=6) then
            begin
               if((now=1) and (dif<100) and (dif>=70)) then
                  dif:=dif+1
               else if((now=2) and (dif<=100) and (dif>70)) then
                  dif:=dif-1
               else if((now=3) and (lang=1)) then
                  lang:=2
               else if((now=3) and (lang=2)) then
                  lang:=1
               else if((now=4) and (mapx<10) and (mapx>=5)) then
                  mapx:=mapx+1
               else if((now=5) and (mapy<12) and (mapy>=8)) then
                  mapy:=mapy+1
               else if((now=6) and (wordlen<20) and (wordlen>=1)) then
                  wordlen:=wordlen+1
               else if((now=7) and (cheat=1)) then
                  cheat:=0
               else if((now=7) and (cheat=0)) then
                  cheat:=1;
            end;
            {Saða Basma Bitiþ , Press Right End}

            {Sola Basma Baþlangýcý , Press Left Start}
            if(enter=4) then
            begin
               if((now=1) and (dif<=100) and (dif>70)) then
                  dif:=dif-1
               else if((now=2) and (dif<100) and (dif>=70)) then
                  dif:=dif+1
               else if((now=3) and (lang=1)) then
                  lang:=2
               else if((now=3) and (lang=2)) then
                  lang:=1
               else if((now=4) and (mapx<=10) and (mapx>5)) then
                  mapx:=mapx-1
               else if((now=5) and (mapy<=12) and (mapy>8)) then
                  mapy:=mapy-1
               else if((now=6) and (wordlen<=20) and (wordlen>1)) then
                  wordlen:=wordlen-1
               else if((now=7) and (cheat=1)) then
                  cheat:=0
               else if((now=7) and (cheat=0)) then
                  cheat:=1;
            end;
            {Sola Basma Bitiþ , Press Left End}

            pointer(8,enter);
            if(enter=3) then
               now:=2;
         until(((enter=0) and (now=8))or(enter=3));
      end;
      {Ayarlar Bitiþ, Settings End}
      {Oyun Baþlangýcý, Game Start}
      if (now=1) then
      begin
         clrscr();
         for i:=1 to mapy do
         begin
            for j:=1 to mapx do
            begin
               map[j,i]:=0;
            end;
         end;
         for i:=1 to mapy do
         begin
            for j:=1 to mapx do
            begin
               starmap[j,i]:='*';
            end;
         end;
         for i:=1 to mapy do
         begin
            j:=0;
            while(j<((mapx*(100-dif)) div 100)) do
            begin
               index:=Random(mapx)+1;
               if(map[index,i]=0) then
               begin
                  map[index,i]:=(Random(3)+1);
                  j:=j+1;
               end;
            end;
         end;
         for i:=1 to wordlen do
         begin
            //randomchar[i]:=chr((Random(94)+33));{Ascii Tablosundan Random Char Alma}
            randomchar[i]:=str[(Random(Length(Str))+1)];{Bir Arrayden Random Char Alma}
         end;
         m:=1;
         k:=1;
         {Oynanýþ Baþlangýç, Gameplay Start}
         timerstart;
         while(m<=mapx) do
         begin
            k:=1;
            enter:=1;
            repeat
               clrscr;
               gamename();
               for i:=1 to mapy do
               begin
                  for j:=1 to mapx do
                  begin
                     if((i=k) and (j=m)) then
                        write('>[',starmap[j,i],']<')
                     else
                        write(' [',starmap[j,i],'] ');
                  end;
                  writeln();
               end;
               {Hile Baþlangýcý,Cheat Start}
               if(cheat=1) then
               begin
			      for i:=1 to mapy do
                  begin
                     for j:=1 to mapx do
                     begin
                           write('[',map[j,i],']');
                     end;
                     writeln();
                  end;
               end;
               {Hile Bitiþi,Cheat End}
               enter:=arrow();
               if((enter=2) and (k<mapy))  then
                  k:=k+1
               else if((enter=8) and (k>1)) then
                  k:=k-1;
               if (enter=3) then
                  m:=mapx;
            until((enter=0)or(enter=3));
            if(enter=0) then
            begin
               if(map[m,k]=0) then
               begin
                  moves[m]:=k;
                  starmap[m,k]:='P';
                  m:=m+1;
               end
               else
               begin
                  {eski haline çevirmek için counterlarý m yap(zýplama efekti)}
                  oldm:=m;
                  counter:=m-map[m,k];
                  if(counter<1) then
                    counter:=1;
                  repeat
                    m:=oldm;
                    starmap[oldm,moves[oldm]]:='*';
                    clrscr;
                    gamename();
                    for i:=1 to mapy do
                    begin
                       for j:=1 to mapx do
                       begin
                          if((i=k) and (j=m)) then
                             write('>[',starmap[j,i],']<')
                          else
                             write(' [',starmap[j,i],'] ');
                        end;
                        writeln();
                    end;
                    delay(100);
                 oldm:=oldm-1;
                 until(oldm=counter-1);
               end;
            end
            else if(enter=3) then
               m:=mapx+1;
         end;
         if(enter<>3) then
         begin
         time1:=timerstop();
         clrscr;
         timerstart;
         repeat
            enter:=1;
            clrscr;
            gamename();
            write(' ');
            for i:=1 to wordlen do
            begin
               write(randomchar[i],' ');
            end;
            writeln();
            writeln(language[lang,12]);
            enter:=arrow();
            if(enter=0) then
            begin
               clrscr;
               gamename();
               writeln(language[lang,13]);
               if(cheat=1) then
               begin
                  for i:=1 to wordlen do
                  begin
                     write(randomchar[i],' ');
                  end;
                  writeln();
               end;
               write('->');
               readln(guess);
               k:=1;
               {Tahmin Kontrolu Baþlangýcý, Guess Controll Start}
               for i:=1 to (Length(guess)) do
               begin
                  if(guess[i]<>' ') then
                  begin
                     if(randomchar[k]=guess[i]) then
                     begin
                        k:=k+1;
                     end;
                  end;
               end;
               {Tahmin Kontrolu Bitiþi, Guess Controll End}
            end;
         until((k-1)=wordlen);
         time2:=timerstop();
         score:=(((100-dif)*mapx*mapy)/time1*100000)+(wordlen*wordlen/time2*100000);{Puanlama,Scoring}
         if(score>=scorepoint[10]) then
         begin
            repeat
            clrscr;
            gamename();
            if(lang=1) then
               writeln(' Bitirme sureniz: ',(time1+time2):0:0,' saniye')
            else
               writeln(' Finish time: ',(time1+time2):0:0,' seconds');
            writeln(language[lang,14]);
            writeln(language[lang,15]);
            write('->');
            readln(name);
            until(name<>'');
            scorepoint[10]:=score;
            scorename[10]:=name;
            for i:=9 downto 1 do
            begin
               for j:=9 downto 1 do
               begin
                  if(scorepoint[j+1]>scorepoint[j]) then
                  begin
                     tmpint:=scorepoint[j+1];
                     scorepoint[j+1]:=scorepoint[j];
                     scorepoint[j]:=tmpint;
                     tmpstr:=scorename[j+1];
                     scorename[j+1]:=scorename[j];
                     scorename[j]:=tmpstr;
                  end;
               end;
            end;
         end;
         {Oynanýþ Bitiþi, Gameplay End}
         clrscr;
         gamename();
         writeln(language[lang,16]);
         writeln(' ->',language[lang,11]);
         readln();
      end;
      end;
      {Oyun Bitiþ, Game End}
   end;
end.
{Ana Program Bitiþi,Main End}
