
{ MEMORY BLOCKS by Przemek Sobstel }

PROGRAM MemoryBlocks;

USES
     Graph,Crt,
     Bmp,Mysz,
     Drivers;

CONST
       ENTER=#13;
       ESC=#27;
       F1=#59;
       F2=#60;
       F3=#61;
       F4=#62;
       F5=#63;
       IloscBlokow=18;

VAR
    Sterownik,Tryb,
    Pixels,Score, {zmienne pomocnicze}
    KolPixel,
    BKolTyl,BKolObw, {kolory kwadracik¢w}
    BStylTyl,TekstKol,KolPom,KolLini,
    X1,Y1,X2,Y2,Odl,Licz,Hlp1
     : Integer;
    First,Second,ZnPary,
    LiniaPliku
     : Byte;
    Rozmiar,
    Czas,Pary,Sec,OldSec
     : Word;
    X,Y
     : array[1..IloscBlokow]of Word;
    BKol
     : array[1..8] of array[1..4] of Word;
    Blok,B
     : array[1..IloscBlokow] of Pointer;
    BTyl, {kwadraciki}
    Liscie,Domki,Liana,Raz,Dwa
     : Pointer;
    SCzas,SPary,Naglowek,TekstPliku,Imie,Hlp2
     : String;
    Name
     : array[1..2] of array[1..5] of string;
    Time,Pair
     : array[1..5] of integer;
    NacKl,Litera
     : Char;
    HiscoresFile,SetupFile
     : Text;
    Gra,Best,Help,
    Option,
      Ster,Kol,Styl,
    Litery,STlos,KTlos,Koniec
     : Boolean;
    BIs
     : array[1..IloscBlokow] of Boolean;


   function ONow:boolean;
      begin
        if (mx>75) and (mx<153) then onow:=true
        else onow:=false;
      end;
   function ONaj:boolean;
      begin
        if (mx>180) and (mx<256) then onaj:=true
        else onaj:=false;
      end;
   function Oopc:boolean;
      begin
        if (mx>278) and (mx<360) then oopc:=true
        else oopc:=false;
      end;
   function OPom:boolean;
      begin
        if (mx>383) and (mx<460) then opom:=true
        else opom:=false;
      end;
   function OWyj:boolean;
      begin
        if (mx>483) and (mx<561) then owyj:=true
        else owyj:=false;
      end;


procedure GetSec(var Second:Word); assembler;
asm
	MOV	AH,2CH
	INT	21H
	XOR	AH,AH
	MOV	AL,DH
	LES	DI,Second
	STOSW
end;

   procedure Block(x,y,kolorobw,rodzajwypel,kolorwypel:integer);
      var normal:word;
      begin
        normal:=getcolor;
        setcolor(kolorobw);
        rectangle(x,y,x+70,y+70);
        setfillstyle(rodzajwypel,kolorwypel);
        bar(x+1,y+1,x+69,y+69);
        setcolor(normal);
      end;

 PROCEDURE WczytanieBlokow;
   var image,x,y,w1,w2:word;
       napis:string;
   begin
     x:=285;y:=142;
     settextstyle(1,0,1);
     setcolor(10);
     napis:='TRWA WCZYTYWANIE DANYCH ...';
     setcolor(10);
     outtextxy(round((640-textwidth(napis))/2),y+110,napis);
     {cz©˜† tylna kwadraciku}
       setfillstyle(BStylTyl,BKolTyl);
       bar(x,y,x+70,y+70);
       setcolor(BKolObw);
       rectangle(x,y,x+70,y+70);
       Rozmiar:=ImageSize(x,y,x+70,y+70);
       GetMem(BTYL,rozmiar);
       GetImage(x,y,x+70,y+70,BTYL^);
     {koniec wczytywania tylnej cz©˜ci kwadracika}
     {images}
       for image:=1 to 9 do
           begin
             Block(x,y,10,1,15);
             case image of
              1 : begin
                    setcolor(12);
                    w1:=30;w2:=1;
                    repeat
                      ellipse(x+35,y+35,0,360,w1,w2);
                      dec(w1);inc(w2);
                    until w1=15;
                    setfillstyle(1,15);setcolor(15);
                    sector(x+35,y+35,200,340,10,2);
                  end;
              2 : begin
                    setcolor(bkol[2,1]);
                    setfillstyle(1,bkol[2,2]);
                    sector(x+35,y+35,0,330,27,27);
                    setcolor(bkol[2,3]);
                    circle(x+47,y+21,1);
                  end;
              3 : begin
                    setcolor(bkol[3,1]);
                    setfillstyle(1,bkol[3,2]);
                    sector(x+35,y+35,0,180,27,27);
                    setcolor(bkol[3,3]);
                    setfillstyle(1,bkol[3,4]);
                    sector(x+35,y+50,0,360,10,15);
                  end;
              4 : begin
                    setcolor(bkol[4,1]);
                    setfillstyle(1,bkol[4,2]);
                    sector(x+35,y+62,30,150,30,55);
                    setcolor(bkol[4,3]);
                    circle(x+28,y+25,1);
                    circle(x+43,y+25,1);
                    ellipse(x+35,y+26,220,320,12,20);
                  end;
              5 : begin
                    setfillstyle(1,bkol[5,1]);
                    bar(x+28,y+10,x+42,y+60);
                    bar(x+15,y+20,x+55,y+34);
                  end;
              6 : begin
                    w1:=10;w2:=60;
                    randomize;
                    repeat
                        inc(w1);dec(w2);
                        setcolor(random(15));
                        line(x+w1,y+10,x+w2,y+60);
                    until w1=60;
                    repeat
                        inc(w2);dec(w1);
                        setcolor(random(15));
                        line(x+10,y+w1,x+60,y+w2);
                    until w1=10;
                  end;
              7 : begin
                    randomize;
                    setfillstyle(1,bkol[7,1]);setcolor(bkol[7,1]);
                    sector(x+35,y+35,0,360,25,25);
                    setfillstyle(1,random(15));
                    bar(x+18,y+18,x+52,y+52);
                    setfillstyle(1,bkol[7,2]);setcolor(bkol[7,2]);
                    sector(x+35,y+35,0,360,17,17);
                    setfillstyle(1,random(15));
                    bar(x+23,y+23,x+47,y+47);
                    setfillstyle(1,bkol[7,3]);setcolor(bkol[7,3]);
                    sector(x+35,y+35,0,360,8,8);
                    setfillstyle(1,random(15));
                    bar(x+32,y+32,x+38,y+38);
                  end;
              8 : begin
                    w1:=10;w2:=60;
                    repeat
                      setcolor(bkol[8,1]);
                      moveto(x+35,y+w1);
                      lineto(x+w1,y+35);
                      lineto(x+35,y+w2);
                      lineto(x+w2,y+35);
                      lineto(x+35,y+w1);
                      inc(w1);dec(w2);
                      inc(bkol[8,1]);
                    until w1>w2;
                  end;
              9 : loadbmp(x+1,y+1,'blok.mbl');
             end;
             Rozmiar:=ImageSize(x,y,x+70,y+70);
             GetMem(blok[image],rozmiar);
             GetImage(x,y,x+70,y+70,blok[image]^);
           end;
     Block(x,y,0,1,0);
     {images - koniec wczytywania}
     {li˜cie - najlepsi}
     loadbmp(74,160,'leaves.mbl');
     Rozmiar:=ImageSize(74,160,566,179);
     GetMem(liscie,rozmiar);
     GetImage(74,160,566,179,liscie^);
     {liana - opcje}
     setfillstyle(1,0);
     bar(32,160,608,172);
     loadbmp(32,160,'line.mbl');
     Rozmiar:=ImageSize(42,160,598,172);
     GetMem(liana,rozmiar);
     GetImage(42,160,598,172,liana^);
     {domki - pomoc}
     bar(32,160,608,172);
     loadbmp(74,160,'houses.mbl');
     Rozmiar:=ImageSize(74,160,572,182);
     GetMem(domki,rozmiar);
     GetImage(74,160,572,182,domki^);
     {do znikania blok¢w}
     Raz:=btyl;
     Dwa:=btyl;
   end;

 PROCEDURE GrafikaPoczatkowa; {zapami©tanie obraz¢w do wy˜wietlania}
   var tytul:string;
       napis:array[1..4]of string;
   begin
     cleardevice;
     loadbmp(70,odl+10,'menu.mbl');
     setcolor(lightgreen);
     settextstyle(0,0,2);
     tytul:='MEMORY BLOCKS';
     napis[1]:='15.12.1999 freeware';
     napis[2]:='Przemek Sobstel';
     outtextxy(round((640-textwidth(tytul))/2),240,tytul);
     settextstyle(0,0,1);
     outtextxy(round((640-textwidth(napis[1]))/2),270,napis[1]);
     outtextxy(round((640-textwidth(napis[2]))/2),300,napis[2]);
     outtextxy(round((640-textwidth(napis[3]))/2),315,napis[3]);
     outtextxy(round((640-textwidth(napis[4]))/2),330,napis[4]);
   end;

 PROCEDURE RozmieszczenieBlokow; {losowanie}
   const Obrazek:array[1..iloscblokow]of word=(1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9);
   var Max,Nr,NrObrazka,NrObr,Odlicz:word;
   begin
     for nrobr:=1 to 9 do
       begin
         obrazek[nrobr]:=nrobr;
         obrazek[nrobr+9]:=nrobr;
       end;
     randomize;
     max:=iloscblokow;
     obrazek[1]:=1;
     for nr:=1 to iloscblokow do
       begin
         nrobrazka:=random(max)+1;
         b[nr]:=blok[obrazek[nrobrazka]];
         bis[nr]:=true;
         for odlicz:=nrobrazka to max do
           begin
             if (nrobrazka<max) and (nrobrazka>0) then
                obrazek[nrobrazka]:=obrazek[nrobrazka+1];
                inc(nrobrazka);
           end;
         dec(max);
       end;
   end;

{****************************************************************************}

PROCEDURE BLOKI;
 var Igrek,NrBloku:word;
 begin
   mukryj;
   gra:=true;
   best:=false;
   option:=false;
   help:=false;
   First:=0;raz:=btyl;
   Second:=0;dwa:=btyl;
   Czas:=0;getsec(oldsec);
   Pary:=0;
   ZnPary:=0;
   RozmieszczenieBlokow; {losowanie}
   x[1]:=60;y[1]:=155;
   for igrek:=2 to 6 do y[igrek]:=y[1];
   for igrek:=7 to 12 do y[igrek]:=y[1]+90;
   for igrek:=13 to 18 do y[igrek]:=y[7]+90;
   x[2]:=x[1]+90;x[3]:=x[2]+90;x[4]:=x[3]+90;x[5]:=x[4]+90;x[6]:=x[5]+90;
   x[7]:=x[1];x[8]:=x[7]+90;x[9]:=x[8]+90;x[10]:=x[9]+90;x[11]:=x[10]+90;x[12]:=x[11]+90;
   x[13]:=x[1];x[14]:=x[13]+90;x[15]:=x[14]+90;x[16]:=x[15]+90;x[17]:=x[16]+90;x[18]:=x[17]+90;
   setfillstyle(1,0);
   bar(odl+1,140,getmaxx-odl-1,getmaxy-odl-1);
    settextstyle(0,0,1);setcolor(15);
    for nrbloku:=1 to iloscblokow do
      begin
        putimage(x[nrbloku],y[nrbloku],btyl^,normalput);
        if litery then outtextxy(x[nrbloku]+33,y[nrbloku]+33,chr(nrbloku+64));
      end;
   setcolor(tekstkol);
   settextstyle(1,0,1);
   str(pary,spary);outtextxy(getmaxx-odl-55,getmaxy-odl-32,spary);
   outtextxy(getmaxx-odl-120,getmaxy-odl-32,'Pary : ');
   str(czas,sczas);outtextxy(getmaxx-odl-175,getmaxy-odl-32,sczas);
   outtextxy(getmaxx-odl-240,getmaxy-odl-32,'Czas : ');
   mpokaz;
 end;

PROCEDURE NAJLEPSI;
 var nag1,nag2,r:string;
     STime,SPair,BTime,BPair:array[1..5] of string;
     Count:integer;
 begin
   mukryj;
   gra:=false;
   best:=true;
   option:=false;
   help:=false;
   setfillstyle(1,0);
   bar(odl+1,140,getmaxx-odl-1,getmaxy-odl-1);
   putimage(74,140,liscie^,normalput);
   putimage(74,420,liscie^,normalput);
   setcolor(kollini);
   line(322,210,322,410);
   settextstyle(0,0,2);
   setcolor(15);
   naglowek:='NAJLEPSZE WYNIKI';
   outtextxy(round((640-textwidth(naglowek))/2),178,naglowek);
   settextstyle(1,0,1);
   setcolor(10);
   nag1:='NAJSZYBCIEJ';
   nag2:='NAJMNIEJ PAR';
   outtextxy(74+round((248-textwidth(nag1))/2),208,nag1);
   outtextxy(322+round((248-textwidth(nag2))/2),208,nag2);
   setcolor(15);
   for count:=1 to 5 do
     begin
       str(time[count],stime[count]);
       str(count,r);
       btime[count]:=r+'.'+name[1,count]+'  '+stime[count]+'s';
     end;
   outtextxy(80+round((230-textwidth(btime[1]))/2),250,btime[1]);
   outtextxy(80+round((230-textwidth(btime[2]))/2),280,btime[2]);
   outtextxy(80+round((230-textwidth(btime[3]))/2),310,btime[3]);
   outtextxy(80+round((230-textwidth(btime[4]))/2),340,btime[4]);
   outtextxy(80+round((230-textwidth(btime[5]))/2),370,btime[5]);
   for count:=1 to 5 do
     begin
       str(pair[count],spair[count]);
       str(count,r);
       bpair[count]:=r+'.'+name[2,count]+'  '+spair[count];
     end;
   outtextxy(333+round((230-textwidth(bpair[1]))/2),250,bpair[1]);
   outtextxy(333+round((230-textwidth(bpair[2]))/2),280,bpair[2]);
   outtextxy(333+round((230-textwidth(bpair[3]))/2),310,bpair[3]);
   outtextxy(333+round((230-textwidth(bpair[4]))/2),340,bpair[4]);
   outtextxy(333+round((230-textwidth(bpair[5]))/2),370,bpair[5]);
   mpokaz;
 end;

PROCEDURE OPCJE;
 begin
   mukryj;
   gra:=false;
   best:=false;
   option:=true;
    ster:=true;
    kol:=false;
    styl:=false;
   help:=false;
   setfillstyle(1,0);
   bar(odl+1,140,getmaxx-odl-1,getmaxy-odl-1);
   putimage(42,140,liana^,normalput);
   putimage(42,425,liana^,normalput);
   setcolor(kollini);
   line(52,190,590,190);
   line(52,220,590,220);
   line(52,400,590,400);
   line(128,294,522,294);
   settextstyle(0,0,1);setcolor(15);
   outtextxy(307,301,'Wz¢r');
   outtextxy(302,256,'Kolor');
   setcolor(15);settextstyle(0,0,2);
   naglowek:='OPCJE';
   outtextxy(round((640-textwidth(naglowek))/2),166,naglowek);
   settextstyle(0,0,2);
   outtextxy(255,343,#17);
   outtextxy(373,343,#16);
   outtextxy(255,272,#17);
   outtextxy(373,272,#16);
   settextstyle(1,0,1);setcolor(10);
   setcolor(10);
   outtextxy(150,193,'Sterowanie gr¥ : ');
   settextstyle(1,0,2);
   outtextxy(135,225,'WYGL¤D TYLNEJ CZ¨—CI KWADRACIKàW');
   settextstyle(1,0,1);setcolor(15);
   if litery then
      begin
        outtextxy(307,193,'myszka i klawiatura');
        settextstyle(0,0,1);
        outtextxy(128,409,#24+','+#25+' - ruch wska«nikiem.  '+#27+','+#26+' - dokonywanie wyboru.');
        settextstyle(0,0,2);setcolor(15);
        outtextxy(80,199,#26);
      end
   else outtextxy(307,193,'tylko myszka');
   setfillstyle(1,bkoltyl);bar(285,270,355,286);
   setfillstyle(bstyltyl,bkoltyl);bar(285,315,355,385);
   setcolor(10);rectangle(285,315,355,385);
   mpokaz;
 end;

PROCEDURE POMOC;
 begin
   mukryj;
   gra:=false;
   best:=false;
   option:=false;
   help:=true;
   setfillstyle(1,0);
   bar(odl+1,140,getmaxx-odl-1,getmaxy-odl-1);
   putimage(72,140,domki^,normalput);
   putimage(72,420,domki^,normalput);
   setcolor(kollini);
   line(82,205,560,205);
   line(82,405,560,405);
   naglowek:='POMOC';
   setcolor(15);settextstyle(0,0,2);
   outtextxy(round((640-textwidth(naglowek))/2),178,naglowek);
   setcolor(KolPom);settextstyle(1,0,1);
   outtextxy(95,220,'Gra si© poprzez odkrywanie kwadrat¢w (lewym');
   outtextxy(95,240,'przyciskiem myszki) i dopasowywanie ich parami.');
   outtextxy(95,260,'Zadanie jest o tyle utrudnione, ¾e w danym');
   outtextxy(95,280,'momencie mog¥ by† odkryte co najwy¾ej tylko');
   outtextxy(95,300,'dwa kwadraty.');
   outtextxy(95,320,'Celem gry jest jak najszybsze lub w jak');
   outtextxy(95,340,'najmniejszej ilo˜ci ruch¢w odkrycie wszystkich');
   outtextxy(95,360,'par znajduj¥cych si© na planszy.');
   mpokaz;
 end;

{****************************************************************************}

PROCEDURE Odkrycie(nrbloku:word);
 var x1,x2,x3,x4,x5,x6,xA,yA,xB,yB,dlgB:integer;
 begin
 if bis[nrbloku] then
 begin
   mukryj;
   if first=0 then begin first:=nrbloku;raz:=b[nrbloku] end {gdy nie odkryte ¾adne obrazki - ukazanie nowego (pierwszego) }
   else
   if second=0 then {gdy odkryty tylko jeden obrazek - ukazanie nowego (deugiego) }
      begin
      second:=nrbloku;
      if second=first then begin second:=0  end
      else begin
             dwa:=b[nrbloku];
             inc(pary);
           end;
      end
   else {gdy odkryte dwa obrazki - odwr¢cenie ich i ukazanie nowego}
     begin
          x3:=x[first];x4:=x3+70;
          x5:=x[second];x6:=x5+70;
           repeat
            setfillstyle(1,0);
            setcolor(0);
            bar(x3,y[first],x4,y[first]+70);
            bar(x5,y[second],x6,y[second]+70);
            inc(x3,7);dec(x4,7);
            inc(x5,7);dec(x6,7);
            setcolor(bkolobw);
            rectangle(x3,y[first],x4,y[first]+70);
            rectangle(x5,y[second],x6,y[second]+70);
            delay(2);
          until (x3=x4+70) or (x5=x6+70);
            putimage(x4,y[first],btyl^,normalput);
            putimage(x6,y[second],btyl^,normalput);
             if Litery then begin
                settextstyle(0,0,1);setcolor(15);
                outtextxy(x4+33,y[first]+33,chr(first+64));
                outtextxy(x6+33,y[second]+33,chr(second+64));end;
          first:=nrbloku;raz:=b[nrbloku];
          second:=0;dwa:=btyl;
     end;

   x1:=x[nrbloku];x2:=x1+70;
   repeat {odsˆoni©cie bloku / ukazanie obrazka}
     setfillstyle(1,0);
     setcolor(0);
     bar(x1,y[nrbloku],x2,y[nrbloku]+70);
     inc(x1,2);dec(x2,2);
     setcolor(bkolobw);
     rectangle(x1,y[nrbloku],x2,y[nrbloku]+70);
   until x1=x2+70;

   {wy˜wietlenie odpowieniego obrazka}
   putimage(x2,y[nrbloku],b[nrbloku]^,normalput);

   if raz=dwa then  {gdy wybrane dwa takie same obrazki}
          begin
            xA:=x[first];yA:=y[first];
            xB:=x[second];yB:=y[second];
            dlgb:=70;
          repeat
            setcolor(bkolobw);
            rectangle(xA,yA,xA+dlgb,yA+dlgb);
            rectangle(xB,yB,xB+dlgb,yB+dlgb);
            delay(3);
            setfillstyle(1,0);
            setcolor(0);
            rectangle(xA,yA,xA+dlgb,yA+dlgb);
            rectangle(xB,yB,xB+dlgb,yB+dlgb);
            inc(xA);inc(xB);
            inc(yA);inc(yB);
            dec(dlgb,2);
          until dlgb<0;
            bis[first]:=false;
            bis[second]:=false;
            first:=0;second:=0;
            inc(znpary);
          end;

    {czas i pary}
    settextstyle(1,0,1);setcolor(0);
    outtextxy(getmaxx-odl-55,getmaxy-odl-32,spary);
    str(pary,spary);
    setcolor(15);
    outtextxy(getmaxx-odl-55,getmaxy-odl-32,spary);
    {cz i p -end}
    mpokaz;
 end;
 end;

{****************************************************************************}
{do OPCJI}

 procedure Sterowanie;
   begin
     mukryj;
     settextstyle(1,0,1);
     setcolor(0);
     if litery then
        begin
          outtextxy(307,193,'myszka i klawiatura');
          settextstyle(0,0,1);
          outtextxy(128,409,#24+','+#25+' - ruch wska«nikiem.  '+#27+','+#26+' - dokonywanie wyboru.');
          setcolor(15);settextstyle(1,0,1);
          outtextxy(307,193,'tylko myszka');
          settextstyle(0,0,2);setcolor(0);
          outtextxy(80,199,#26);outtextxy(80,273,#26);outtextxy(80,342,#26);
          litery:=false;
        end
     else
        begin
          outtextxy(307,193,'tylko myszka');
          setcolor(15);
          outtextxy(307,193,'myszka i klawiatura');
          settextstyle(0,0,1);
          outtextxy(128,409,#24+','+#25+' - ruch wska«nikiem.  '+#27+','+#26+' - dokonywanie wyboru.');
          settextstyle(0,0,2);setcolor(15);
          outtextxy(80,199,#26);
          litery:=true;
        end;
     mpokaz;
   end;

{****************************************************************************}

BEGIN
  assign(hiscoresfile,'HISCORES.MBL');
  assign(setupfile,'CONFIG.MBL');
  {$I-}
  reset(hiscoresfile);
  if IOResult<>0 then begin writeln('Bˆ¥d odczytu - plik HISCORES.MBL.');halt(1) end;
  reset(setupfile);
  if IOResult<>0 then begin writeln('Bˆ¥d pliku konfiguracyjnego.');halt(1) end;
  {$I+}

  readln(setupfile,liniapliku);
  if liniapliku=1 then litery:=true else litery:=false;
  readln(setupfile,liniapliku);
  randomize;
  if liniapliku=0 then begin bstyltyl:=random(11)+1;STlos:=true end
     else begin bstyltyl:=liniapliku;STlos:=false end;
  readln(setupfile,liniapliku);
  if liniapliku=0 then begin bkoltyl:=random(15)+1;KTlos:=true end
     else begin bkoltyl:=liniapliku;KTlos:=false end;

  reset(hiscoresfile);
      for score:=1 to 5 do
          begin
            readln(hiscoresfile,name[1,score]);
            readln(hiscoresfile,time[score]);
          end;
      for score:=1 to 5 do
          begin
            readln(hiscoresfile,name[2,score]);
            readln(hiscoresfile,pair[score])
          end;

  if (RegisterBGIdriver(@VGADr)<0) or (RegisterBGIfont(@TRIPFt)<0) then halt(1);
  sterownik:=installuserdriver('SVGA256',nil);
  Tryb:=0;
  InitGraph(sterownik,Tryb,'');
  x2:=-2;y2:=-2;
  x1:=321;y1:=201;
  settextstyle(1,0,1);
  repeat
    inc(x2,3);inc(y2,3);dec(x1,6);dec(y1,6);
    randomize;
    for Pixels:=1 to 450 do
    putpixel(x2+random(x1)+1,y2+random(y1)+1,random(256));
    setcolor(random(255)+1);
    if x2>100 then setcolor(15);
    outtextxy(81,90,'MEMORY BLOCKS');
  until (x2>80) or (keypressed);
    setfillstyle(1,0);
    bar(73,90,233,113);
    setcolor(15);
    outtextxy(81,90,'MEMORY BLOCKS');
  readkey;
  closegraph;
  sterownik:=VGA;tryb:=VGAHi;
  initgraph(Sterownik,tryb,'');

  Odl:=25;
  Koniec:=False;
  Gra:=False;
  Best:=False;
  Help:=False;
  TekstKol:=15;
  KolLini:=green;
  KolPom:=12; {kolor tekstu pomocy}
   {kolory kwadracik¢w}
   BKolObw:=10;
    { 1 - Usta ? }
    BKol[1,1]:=14; {wypeˆnienie}
    { 2 - Potworek }
    BKol[2,1]:=14; {obw¢dka}
    BKol[2,2]:=12; {wewn.wypeˆnienie}
    BKol[2,3]:=15; {oko}
    { 3 - Grzybek }
    BKol[3,1]:=14; {obw¢dka kapturka}
    BKol[3,2]:=12; {wewn.wypeˆnienie kapturka}
    BKol[3,3]:=11; {obw¢dka doˆu}
    BKol[3,4]:=11; {wewn.wypeˆnienie doˆu}
    { 4 - U˜miechni©ty potworek }
    BKol[4,1]:=10; {obw¢dka}
    BKol[4,2]:=13; {wypeˆnienie}
    BKol[4,3]:=15; {u˜miech i oczy}
    { 5 - Krzy¾ }
    BKol[5,1]:=0; {wypeˆnienie krzy¾a}
    { 6 - Kalejdoskop lini }
    { kolory s¥ losowane }
    { 7 - K¢ˆka i kwadraty }
    BKol[7,1]:=9; {I-wsze k¢ˆko}
    BKol[7,2]:=10; {II-gie k¢ˆko}
    BKol[7,3]:=11; {III-cie k¢ˆko}
    { 8 - Kafelek }
    BKol[8,1]:=9; {pierwszy kolor}
    { 9 - Choinka }
    { czytane z pliku BLOK.MBL }

  WczytanieBlokow;
  GrafikaPoczatkowa;
  MInit;
  MZasieg(odl+3,odl+2,getmaxx-odl-12,getmaxy-odl-20);
  MPokaz;
  MUstaw(odl,odl);

  REPEAT  {gˆ¢wna p©tla programu}

    if MLB then
       begin
         if (my>94) and (my<116) then
            begin
              if onow then Bloki
              else if onaj then Najlepsi
              else if oopc then Opcje
              else if opom then Pomoc
              else if owyj then koniec:=true;
            end
         else
         if GRA and (my>120) then
            begin
            if (mx>x[1]) and (my>y[1]) and (mx<x[1]+70) and (my<y[1]+70) then odkrycie(1)
            else if (mx>x[2]) and (my>y[2]) and (mx<x[2]+70) and (my<y[2]+70) then odkrycie(2)
            else if (mx>x[3]) and (my>y[3]) and (mx<x[3]+70) and (my<y[3]+70) then odkrycie(3)
            else if (mx>x[4]) and (my>y[4]) and (mx<x[4]+70) and (my<y[4]+70) then odkrycie(4)
            else if (mx>x[5]) and (my>y[5]) and (mx<x[5]+70) and (my<y[5]+70) then odkrycie(5)
            else if (mx>x[6]) and (my>y[6]) and (mx<x[6]+70) and (my<y[6]+70) then odkrycie(6)
            else if (mx>x[7]) and (my>y[7]) and (mx<x[7]+70) and (my<y[7]+70) then odkrycie(7)
            else if (mx>x[8]) and (my>y[8]) and (mx<x[8]+70) and (my<y[8]+70) then odkrycie(8)
            else if (mx>x[9]) and (my>y[9]) and (mx<x[9]+70) and (my<y[9]+70) then odkrycie(9)
            else if (mx>x[10]) and (my>y[10]) and (mx<x[10]+70) and (my<y[10]+70) then odkrycie(10)
            else if (mx>x[11]) and (my>y[11]) and (mx<x[11]+70) and (my<y[11]+70) then odkrycie(11)
            else if (mx>x[12]) and (my>y[12]) and (mx<x[12]+70) and (my<y[12]+70) then odkrycie(12)
            else if (mx>x[13]) and (my>y[13]) and (mx<x[13]+70) and (my<y[13]+70) then odkrycie(13)
            else if (mx>x[14]) and (my>y[14]) and (mx<x[14]+70) and (my<y[14]+70) then odkrycie(14)
            else if (mx>x[15]) and (my>y[15]) and (mx<x[15]+70) and (my<y[15]+70) then odkrycie(15)
            else if (mx>x[16]) and (my>y[16]) and (mx<x[16]+70) and (my<y[16]+70) then odkrycie(16)
            else if (mx>x[17]) and (my>y[17]) and (mx<x[17]+70) and (my<y[17]+70) then odkrycie(17)
            else if (mx>x[18]) and (my>y[18]) and (mx<x[18]+70) and (my<y[18]+70) then odkrycie(18);
            end
         else
         if OPTION and (my>190) then
            begin
              mukryj;
              {sterowanie}
              if (mx>52) and (mx<590) and (my>190) and (my<220) then Sterowanie;
              {kolor}
              if (mx>254) and (mx<270) and (my>270) and (my<285) and (bkoltyl>=0) then
                 begin
                   if bkoltyl=0 then
                      begin
                        setfillstyle(1,0);
                        bar(285,270,355,286);
                        settextstyle(0,0,1);setcolor(15);
                        outtextxy(288,275,'losowany');
                        ktlos:=true;
                      end
                   else begin
                          dec(bkoltyl);
                          setfillstyle(1,bkoltyl);
                          bar(285,270,355,286);
                          if bstyltyl>0 then begin
                          setfillstyle(bstyltyl,bkoltyl);
                          bar(285,315,355,385);end;
                          ktlos:=false;
                        end;
                 end;
              if (mx>371) and (mx<388) and (my>270) and (my<285) and (bkoltyl<15) then
                 begin
                   inc(bkoltyl);
                   setfillstyle(1,bkoltyl);
                   bar(285,270,355,286);
                   if bstyltyl>0 then begin
                   setfillstyle(bstyltyl,bkoltyl);
                   bar(285,315,355,385);end;
                   ktlos:=false;
                 end;
              {wz¢r}
              if (mx>254) and (mx<270) and (my>342) and (my<358) and (bstyltyl>=0) then
                 begin
                   if bstyltyl=0 then
                      begin
                        setfillstyle(1,1);bar(285,315,355,385);
                        settextstyle(0,0,1);setcolor(15);
                        outtextxy(288,345,'losowany');
                        stlos:=true;
                      end
                   else begin
                          dec(bstyltyl);
                          if bkoltyl=0 then setfillstyle(bstyltyl,random(15)+1)
                          else setfillstyle(bstyltyl,bkoltyl);
                          bar(285,315,355,385);
                          stlos:=false;
                        end;
                 end;
              if (mx>371) and (mx<388) and (my>340) and (my<357) and (bstyltyl<11) then
                 begin
                   inc(bstyltyl);
                   if bkoltyl=0 then setfillstyle(bstyltyl,random(15)+1)
                   else setfillstyle(bstyltyl,bkoltyl);
                   bar(285,315,355,385);
                   stlos:=false;
                 end;
              setcolor(BKolObw);
              rectangle(285,315,355,385);
              Rozmiar:=ImageSize(285,315,355,385);
              GetMem(BTYL,rozmiar);
              GetImage(285,315,355,385,BTYL^);
              mpokaz;
            end
         {HELP i BEST nie potrzebne, bo tylko napisy}
       end;

    if keypressed then
       begin
         NacKl:=upcase(readkey);
         case NacKl of
             ESC : koniec:=true;
              F1 : Bloki;
              F2 : Najlepsi;
              F3 : Opcje;
              F4 : Pomoc;
              F5 : koniec:=true;
         end;
         if GRA and LITERY and (nackl>='A') and (nackl<='R') then
            odkrycie(ord(nackl)-64);
         if OPTION and LITERY then
            begin
              mukryj;
              case nackl of
                   #72 : begin
                           if kol then begin kol:=false;ster:=true end
                           else if styl then begin styl:=false;kol:=true end
                         end;
                   #80 : begin
                           if ster then begin ster:=false;kol:=true end
                           else if kol then begin kol:=false;styl:=true end
                         end;
                   #75 : begin
                           if ster then sterowanie;
                           if kol then begin
                      if bkoltyl=0 then
                      begin
                        setfillstyle(1,0);
                        bar(285,270,355,286);
                        settextstyle(0,0,1);setcolor(15);
                        outtextxy(288,275,'losowany');
                        ktlos:=true;
                      end
                   else begin
                          dec(bkoltyl);
                          setfillstyle(1,bkoltyl);
                          bar(285,270,355,286);
                          if bstyltyl>0 then begin
                          setfillstyle(bstyltyl,bkoltyl);
                          bar(285,315,355,385);end;
                          ktlos:=false;
                        end;
                                       end;
                           if styl then begin;
                   if bstyltyl=0 then
                      begin
                        setfillstyle(1,1);bar(285,315,355,385);
                        settextstyle(0,0,1);setcolor(15);
                        outtextxy(288,345,'losowany');
                        stlos:=true;
                      end
                   else begin
                          dec(bstyltyl);
                          if bkoltyl=0 then setfillstyle(bstyltyl,random(15)+1)
                          else setfillstyle(bstyltyl,bkoltyl);
                          bar(285,315,355,385);
                          stlos:=false;
                        end;
                                        end;
              setcolor(BKolObw);
              rectangle(285,315,355,385);
              Rozmiar:=ImageSize(285,315,355,385);
              GetMem(BTYL,rozmiar);
              GetImage(285,315,355,385,BTYL^);
                         end;
                   #77 : begin
                           if ster then sterowanie;
                           if kol and (bkoltyl<15) then begin
                   inc(bkoltyl);
                   setfillstyle(1,bkoltyl);
                   bar(285,270,355,286);
                   if bstyltyl>0 then begin
                   setfillstyle(bstyltyl,bkoltyl);
                   bar(285,315,355,385);end;
                   ktlos:=false;
                                       end;
                           if styl and (bstyltyl<11) then begin
                   inc(bstyltyl);
                   if bkoltyl=0 then setfillstyle(bstyltyl,random(15)+1)
                   else setfillstyle(bstyltyl,bkoltyl);
                   bar(285,315,355,385);
                   stlos:=false;
                                        end;
              setcolor(BKolObw);
              rectangle(285,315,355,385);
              Rozmiar:=ImageSize(285,315,355,385);
              GetMem(BTYL,rozmiar);
              GetImage(285,315,355,385,BTYL^);
                         end;
              end;
              settextstyle(0,0,2);
              setcolor(0);
              if ster=false then outtextxy(80,199,#26);
              if kol=false then outtextxy(80,273,#26);
              if styl=false then outtextxy(80,342,#26);
              if litery then begin
              setcolor(15);
              if ster then outtextxy(80,199,#26)
              else if kol then outtextxy(80,273,#26)
              else if styl then outtextxy(80,342,#26);
                             end;
              mpokaz;
            end;
       end;

    if GRA then
       begin

         if (znpary=iloscblokow/2) or (czas=999) or (pary=999) then
            begin
              gra:=false;
              setfillstyle(1,0);
              bar(odl+1,140,getmaxx-odl-1,getmaxy-odl-1);
              settextstyle(1,0,1);
              if czas=999 then begin
                 setcolor(10);
                 rectangle(180,275,460,310);
                 setcolor(15);
                 outtextxy(188,280,'Przekroczyˆe˜ limit czasowy !');
              end else
              if pary=999 then begin
                 setcolor(10);
                 rectangle(170,275,470,310);
                 setcolor(15);
                 outtextxy(179,280,'Przekroczyˆe˜ limit par (999) !');
              end
              ELSE
               Begin
                 mukryj;
                 {na list©}
                 setcolor(10);
                 if (czas<time[5]) or (pary<pair[5]) then
                    begin
                      rectangle(150,220,510,314);
                      rectangle(255,280,418,308);
                      setcolor(15);
                      outtextxy(178,225,'Znalazˆe˜ si© na li˜cie najlepszych.');
                      outtextxy(157,247,'Wpisz swoje imi© i zatwierd« enterem.');
                      setfillstyle(1,0);imie:='';
                      repeat
                        bar(256,281,417,307);
                        outtextxy(262,280,imie);
                        litera:=readkey;
                        if litera<>#0 then begin
                        if litera=#8 then delete(imie,length(imie),1)
                        else if litera=#13 then continue
                        else if textwidth(imie)<145 then imie:=imie+litera;
                                           end;
                      until litera=#13;
                      if czas<time[5] then
                         begin
                           if czas<time[5] then begin time[5]:=czas;name[1,5]:=imie end;
                           for licz:=4 downto 1 do
                           if czas<time[licz] then
                              begin
                                hlp1:=time[licz];hlp2:=name[1,licz];
                                time[licz]:=czas;name[1,licz]:=imie;
                                time[licz+1]:=hlp1;name[1,licz+1]:=hlp2;
                              end;
                         end;
                      if pary<pair[5] then
                         begin
                           if pary<pair[5] then begin pair[5]:=pary;name[2,5]:=imie end;
                           for licz:=4 downto 1 do
                           if pary<pair[licz] then
                              begin
                                hlp1:=pair[licz];hlp2:=name[2,licz];
                                pair[licz]:=pary;name[2,licz]:=imie;
                                pair[licz+1]:=hlp1;name[2,licz+1]:=hlp2;
                              end;
                         end;
                      najlepsi;
                    end
                 {poza list¥}
                 else if (czas>=time[5]) and (pary>=pair[5]) then
                    begin
                      rectangle(150,220,510,314);
                      setcolor(15);
                      outtextxy(175,230,'Niestety tw¢j wynik jest za sˆaby,');
                      outtextxy(160,255,'¾eby znale«† si© na li˜cie najlepszych.');
                      outtextxy(273,280,'Przykro mi !');
                    end;
                    mpokaz;
               End;
            end
         else begin
         getsec(sec);
           if sec>oldsec then inc(czas,sec-oldsec)
           else if sec<oldsec then inc(czas,60-(oldsec-sec));
         if sec<>oldsec then
            begin
              settextstyle(1,0,1);
              setcolor(0);
              outtextxy(getmaxx-odl-175,getmaxy-odl-32,sczas);
              setcolor(15);
              str(czas,sczas);outtextxy(getmaxx-odl-175,getmaxy-odl-32,sczas);
              oldsec:=sec;
            end;
              end;
       end;

    inc(x2,1);inc(y2,1);dec(x1,2);dec(y1,2);
    randomize;
    for pixels:=1 to 500 do
      begin
        kolpixel:=random(16);
        putpixel(random(odl),random(getmaxy)+1,kolpixel);
        putpixel(random(odl)+getmaxx-odl,random(600)+1,kolpixel);
        putpixel(random(getmaxx)+1,random(odl),kolpixel);
        putpixel(random(getmaxx)+1,random(odl)+getmaxy-1-odl,kolpixel);
      end;

  until KONIEC;

  closegraph;
  rewrite(setupfile);
     if litery then writeln(setupfile,1)
        else writeln(setupfile,0);
     if STlos then writeln(setupfile,0)
        else writeln(setupfile,bstyltyl);
     if KTlos then writeln(setupfile,0)
        else writeln(setupfile,bkoltyl);
  close(setupfile);
  rewrite(hiscoresfile);
      for score:=1 to 5 do
          begin
            writeln(hiscoresfile,name[1,score]);
            writeln(hiscoresfile,time[score]);
          end;
      for score:=1 to 5 do
          begin
            writeln(hiscoresfile,name[2,score]);
            writeln(hiscoresfile,pair[score])
          end;
  close(hiscoresfile);
END.
