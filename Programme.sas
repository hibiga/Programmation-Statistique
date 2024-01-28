LIBNAME rep "/folders/myfolders/TP_1" ;

data rep.AGE1 ;
length NOM $10;
input NOM$ AGE;
cards ;
Cazenave 23
Maisonave 22
Bordenave 25
;
run;
proc print data = rep.AGE1;
run;

data rep.TAILLE;
length NOM $10;
input NOM$ TAILLE;
cards;
Cazenave 175
Bordenave 168
Etebeverry 185
;
run;
proc print data = rep.taille;
run;

proc sort data = rep.AGE1;
by nom;
run;
proc sort data = rep.taille;
by nom;
run;
data rep.jointure ;
merge rep.AGE1 rep.taille;
by nom;
run;
proc print data = rep.jointure;
run;

data rep.taille;
set rep.taille;
IF taille>170 then
TAILCOD='grand';
else TAILCOD='petit';
run;

data rep.taille;
set rep.taille;
TAILLEM=TAILLE*0.01;
run;

proc print data = rep.taille;
run;

data rep.taille;
set rep.taille;
drop taille;
run;
data rep.taille;
set rep.taille;
rename taillem=taille;
run;
proc print data = rep.TAILLE;
run;

data rep.AGE2 ;
length NOM $10;
input NOM$ AGE;
cards ;
Bordagaray 21
Etchegaray 22
;
run;
proc print data = rep.AGE2;
run;

proc sort data = rep.AGE2;
by nom;
run;
data rep.AGE1 ;
set rep.AGE1 rep.AGE2;
run;
proc print data = rep.AGE1;
run;

data rep.age22 ; 
set rep.AGE1 ;
if AGE NE 22 then delete; 
run; 
proc print data = rep.age22;
run;

