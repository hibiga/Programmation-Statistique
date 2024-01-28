/*EXERCICE 1*/
/*1 _ Pour lancer après avoir créé dossier TP_1*/
LIBNAME rep "/folders/myfolders/TP_1" ;

/*2 _ Créer tableaux*/
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

/* 3 _ Jointure*/
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

/*4.1 _ Créer nouvelle variable*/
data rep.taille;
set rep.taille;
IF taille>170 then
TAILCOD='grand';
else TAILCOD='petit';
run;

/*4.B _ Créer nouvelle variable*/
data rep.taille;
set rep.taille;
TAILLEM=TAILLE*0.01;
run;

proc print data = rep.taille;
run;

/*4.C _ Supprimer variable*/
data rep.taille;
set rep.taille;
drop taille;
run;

/*4.D _ Renommer variable*/
data rep.taille;
set rep.taille;
rename taillem=taille;
run;

proc print data = rep.TAILLE;
run;

/*5.A _ Créer table*/
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

/*5.B _ Rajouter table dans une autre*/
proc sort data = rep.AGE2;
by nom;
run;
data rep.AGE1 ;
set rep.AGE1 rep.AGE2;
run;
proc print data = rep.AGE1;
run;

/*5.C _ Sélectionner variable pour nouvelle table (que les 22 ans)*/
data rep.age22 ; 
set rep.AGE1 ;
if AGE NE 22 then delete; 
run; 

proc print data = rep.age22;
run;

/*EXERCICE 2*/
/*Importer données : enregistrer d’abord sur csv point-virgule puis télécharger vers le serveur (sur sas) dans TP_1*/ 
DATA rep.rugby;
INFILE '/folders/myfolders/TP_1/RUGBY.csv'
dlm=';' firstobs=2 missover dsd termstr=CRLF;
INPUT annee club$ taille poids poste$ libelle_poste$ age;
RUN;

proc print data = rep.rugby;
run;

/*Afficher information sur table (liste variables, attributs,  machine,..)*/
proc contents data = rep.rugby;
run;

/*Sélectionner variable pour nouvelle table (que les 1993)*/
data rep.annee1993 ; 
set rep.rugby ;
if annee NE "1993" then delete; 
run; 
proc print data = rep.annee1993;
run;

/*Sélectionner variables pour nouvelle table (les piliers de l’USAP)*/
data rep.piliers ; 
set rep.rugby ;
if club ="USAP" and libelle_poste='Pilier' then output; 
run; 
proc print data = rep.piliers;
run;
