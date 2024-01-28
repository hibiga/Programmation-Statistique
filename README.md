Introductions sur l'utilisations de SAS. 

https://drive.google.com/drive/folders/1DvXhhpxxFJ4qeNfilKFyizZpR9_ihvcA?usp=drive_link

# Pour lancer après avoir créé dossier 
LIBNAME rep "/folders/myfolders/nomdossier" ;

# Créer tableaux
data rep.AGE1 ;
length NOM $10;
input NOM$ AGE;
cards ;
Cazenave 23
Maisonave 22
Bordenave 25
;
run;

# Créer une table avec 30 réalisations de 12 v.a
data toto;
  do i=1 to 30;
    x1=rand('uniform');
    x2=rand('uniform');
    x3=rand('uniform');
    x4=rand('uniform');
    x5=rand('uniform');
    x6=rand('uniform');
    x7=rand('uniform');
    x8=rand('uniform');
    x9=rand('uniform');
    x10=rand('uniform');
    x11=rand('uniform');
    x12=rand('uniform');
    output;
  end;
  drop i;
run;

# Afficher tableau
proc print data = rep.AGE1;
run;

# Jointure
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

# Créer nouvelle variable
## basique
data rep.taille;
set rep.taille;
IF taille>170 then
TAILCOD='grand';
else TAILCOD='petit';
run;
## retain
Data test_bis;
set test;
retain Y 0;
Y=X+Y;
run;
proc print data=test_bis;
run;
Somme successives de X 
Data test_quad;
set test;
retain Y 0;
retain Z 0;
Y=X-Z;
Z=X;
run;
Différences entre deux valeurs successives de X 
# Supprimer variable
data rep.taille;
set rep.taille;
drop taille;
run;

# Renommer variable
data rep.taille;
set rep.taille;
rename taillem=taille;
run;
proc print data = rep.TAILLE;
run;

# Rajouter table dans une autre
proc sort data = rep.AGE2;
by nom;
run;
data rep.AGE1 ;
set rep.AGE1 rep.AGE2;
run;
proc print data = rep.AGE1;
run;

# Sélectionner variable pour nouvelle table (que les 22 ans)
data rep.age22 ; 
set rep.AGE1 ;
if AGE NE 22 then delete; 
run; 
proc print data = rep.age22;
run;

# Importer données : enregistrer d’abord sur csv point-virgule puis télécharger vers le serveur (sur sas) dans TP_1 
DATA rep.rugby;
INFILE '/folders/myfolders/TP_1/RUGBY.csv'
dlm=';' firstobs=2 missover dsd termstr=CRLF;
INPUT annee club$ taille poids poste$ libelle_poste$ age;
RUN;
proc print data = rep.rugby;
run;

# Afficher information sur table (liste variables, attributs, machine,..)
proc contents data = rep.rugby;
run;

# Sélectionner variable pour nouvelle table 
(que les 1993 & les piliers de l’USAP)
data rep.annee1993 ; 
set rep.rugby ;
if annee NE "1993" then delete; 
run; 

data rep.piliers ; 
set rep.rugby ;
if club ="USAP" and libelle_poste='Pilier' then output; 
run; 

# Importer données excel
data rep.caf;
infile '/folders/myfolders/TP_2/caf2006.csv'
dlm=';'
firstobs=2
missover dsd termstr=CRLF; 
input Ident$ ACT_ALLOC$ ACT_CON$ age2006_alloc sexe_alloc age2006_conj annnen1 
informat dtdemrmi ddmmyy10.;
format dtdemrmi ddmmyy10.;
run;

# Si on omet informat et format : 
informat dtdemrmi ddmmyy10. : les dates ne s’affichent plus car elles ne sont pas dans le bon format 
format dtdemrmi ddmmyy10. : l’écriture des dates ne sont pas faites correctement, il manque les « / »

# Avoir l’année et le mois sans la date 
Year(nom var); 
Month(nom var)
12*(2006-Year(dtdemrmi)) + (12-Month(dtdemrmi)); 

# Création formats 
ils se créent indépendamment de la table dans laquelle ils sont censés s’appliquer
proc format; 
value id 1="Oui" 0="Non" ; 
run; 
proc print data = rep.caf; 
format C_ss_enf C_av_enf I_ss_enf I_av_enf id.;
run;

# Utilisation des formats créé
proc print data=sas.RMI2006;
FORMAT C_ss_enf C_av_enf I_ss_enf I_av_enf id. NBENF ENF. SITFAM FAM.  sexe_alloc SEXE.;
RUN;
Pour affecter définitivement : 
DATA sas.RMI2006;
set sas.RMI2006;
FORMAT RMI OUINON. NBENF ENF. SITFAM FAM.  sexe_alloc SEXE.;
RUN;

## Afficher table sans format Homme/Femme
proc print data=sas.RMI2006;
FORMAT sexe_alloc;
RUN;

# Donner libeller 
data rep.rugby;
set rep.rugby;
label annee = 'Année' club='Club' taille='Taille' poids='Poids' poste='Poste' libelle_poste='Libellé du poste' age='Age';
run;

# Récupérer la sortie de proc contents dans une nouvelle table pour avoir la liste des variables
proc contents data = rep.rugby
out = rep.res;
run;

# Moyenne (la taille, poids et age)
proc means data = rep.rugby mean ; 
var taille poids age;
by annee ; [par classe d’année]
run;

# Créer table moyenne par classe 
(attention : préciser que l’on cherche que la moyenne en nommant les nouvelles variables) 
proc means data = rep.rugby mean ;
var taille poids age;
by annee;
output out = rep.ahlala mean=taillemoy poidsmoy agemoy;
run; 
proc print data = rep.ahlala; 
run;

# Afficher quartiles 
(variable poids) : deux méthodes
proc univariate data = rep.rugby; 
var poids; 
run; 

proc means data = rep.rugby P1 P5 P10 P25 P50 P75 P90 P95 P99 QRANGE;
var poids; 
run;

# Classer
proc format;
value classe_poids
low-84="trés léger"
84<-96="léger"
96<-106="lourd"
106<-high="trés lourd";
run;

# Croiser variable avec test du Chi2
proc freq data=rep.rugby;
tables annee*poids / chisq nopercent nofreq nocol; 
format poids classe_poids.;
run; 

# Histogramme
proc univariate data=rep.rugby noprint;
by annee;
histogram poids / midpoints=65 to 145 by 10;
INSET 	N='Effectif' 
		MEAN='Poids Moyen' 
		MIN='Poids minimum'
        MAX='Poids maximum' / HEADER='Statistiques' POSITION=ne FORMAT=4.;
run;
Dans inset : légende 

# Graphique 
Taille par année
proc sort data=rep.rugby;
by annee;
run;
Proc boxplot data=rep.rugby;
plot taille*annee;
run;
## Barres
Nb de piliers par club en 2008
Proc chart data=rep.rugby;
vbar club;
where annee='2008' and poste='PI';
run; 
Poids moyen des piliers par club en 2008
Proc chart data=rep.rugby;
vbar club / sumvar=poids type=mean;
where annee='2008' and poste='PI';
run; 

# Bornes intervalles de confiance 
Récupérer dans une table les bornes des intervalles de confiance de la moyenne pour taille et poids des pilliers en 1993 et 2008
proc means data=rep.rugby alpha=0.05 noprint;
var poids taille;
by annee;
where poste="PI";
output out=rep.toto lclm=borne_inf_poids borne_inf_taille uclm=borne_sup_poids borne_sup_taille; 
run;

proc print data=rep.toto;
run;

# Créer tableaux à l’aide d’un autre 
## Proc tabulate 
Tableau des moyennes et écarts-types de la taille, poids et age par poste et année
PROC TABULATE DATA=rep.rugby;
CLASS annee poste;
VAR taille poids age ;
TABLE poste*annee, (taille poids age)*(MEAN="Moyenne" STD="Ecart type");
where poste in ("PI","2L","CE","AI");
RUN;
Tableau des moyenne et médianes de taille poids et age par année 
PROC TABULATE DATA=rep.rugby;
CLASS annee;
VAR taille poids age ;
TABLE annee, (MEAN="Moyenne" MEDIAN="Médiane")*(taille poids age);
RUN;
## Proc sql
table avec var année, club, taille, poids pour les joueurs mesurant + de 185 ou avec + de28 ans 
PROC SQL;
   CREATE TABLE rep.riri AS 
      SELECT annee,club,taille,poids
      FROM rep.rugby
      WHERE taille > 185 or age = 28;
run;
proc print data=rep.riri;
run;
table avec var année, club, taille, poids pour les joueurs poids sup à la moyenne
PROC SQL;
   CREATE TABLE rep.fifi AS 
      SELECT annee,club,taille,poids, avg(poids) as poidsmoyen
      FROM rep.rugby
      having poids>poidsmoyen
      ;
run;

# Test de normalité 
proc univariate data=toto normal;
var moy;
run;
