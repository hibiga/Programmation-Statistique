LIBNAME rep "/folders/myfolders/TP_3" ;

/*Importer données*/
DATA rep.rugby;
INFILE '/folders/myfolders/TP_3/RUGBY.csv'
dlm=';' firstobs=2 missover dsd termstr=CRLF;
INPUT annee club$ taille poids poste$ libelle_poste$ age;
RUN;
proc print data = rep.rugby;
run;

/*Donner libeller*/
data rep.rugby;
set rep.rugby;
label annee = 'Année' club='Club' taille='Taille' poids='Poids' poste='Poste' libelle_poste='Libellé du poste' age='Age';
run;

/*Récupérer la sortie de proc contents dans une nouvelle table pour avoir la liste des variables*/
proc contents data = rep.rugby
out = rep.res;
run;
proc print data = rep.res; 
run;

/*Pour variables qualitatives*/
data rep.sortie; 
set rep.res; 
if type=1 then DELETE; 
run; 
proc print data = rep.sortie; 
run; 
data rep.sortie2; 
set rep.res; 
if type=2 then DELETE; 
run; 
proc print data = rep.sortie2; 
run;

/*Moyenne de la taille, poids et age*/
proc means data = rep.rugby mean ; 
var taille poids age;
run;

/*Moyenne par classe d’année*/ 
proc means data = rep.rugby mean ; 
var taille poids age;
by annee;
run; 

/*Créer table moyenne par classe (attention : préciser que l’on cherche que la moyenne en nommant les nouvelles variables)*/
proc means data = rep.rugby mean ;
var taille poids age;
by annee;
output out = rep.ahlala mean=taillemoy poidsmoy agemoy;
run; 
proc print data = rep.ahlala; 
run;

/*De même pour minimum et maximum*/
proc means data = rep.rugby ;
var taille poids age;
by annee;
output out = rep.ohlolo min=taillemin poidsmin agemin max=taillemax poidsmax agemax;
run; 
proc print data = rep.ohlolo; 
run;

/*Afficher quartiles variable poids : deux méthodes*/
proc univariate data = rep.rugby; 
var poids; 
run; 

proc means data = rep.rugby P1 P5 P10 P25 P50 P75 P90 P95 P99 QRANGE;
var poids; 
run;

/*Créer 4 classes sur la variable poids*/ 
proc format;
value classe_poids
low-84="trés léger"
84<-96="léger"
96<-106="lourd"
106<-high="trés lourd";
run;

/*Croiser variable poids et l’année avec test du Chi2*/
proc freq data=rep.rugby;
tables annee*poids / chisq nopercent nofreq nocol; 
format poids classe_poids.;
run; 

/*Faire histogramme*/ 
proc univariate data=rep.rugby noprint;
by annee;
histogram poids / midpoints=65 to 145 by 10;
INSET 	N='Effectif' 
		MEAN='Poids Moyen' 
		MIN='Poids minimum'
        MAX='Poids maximum' / HEADER='Statistiques' POSITION=ne FORMAT=4.;
run;

/*Graphique de la taille par année*/ 
proc sort data=rep.rugby;
by annee;
run;

Proc boxplot data=rep.rugby;
plot taille*annee;
run;

/*Graphique en barre : nb de pilliers par club en 2008*/
Proc chart data=rep.rugby;
vbar club;
where annee='2008' and poste='PI';
run; 

/*Graphie en barre : poids moyen des pilliers par club en 2008*/
Proc chart data=rep.rugby;
vbar club / sumvar=poids type=mean;
where annee='2008' and poste='PI';
run; 

/*Récupérer dans une table les bornes des intervalles de confiance de la moyenne pour taille et poids des pilliers en 1993 et 2008*/
proc means data=rep.rugby alpha=0.05 noprint;
var poids taille;
by annee;
where poste="PI";
output out=rep.toto lclm=borne_inf_poids borne_inf_taille uclm=borne_sup_poids borne_sup_taille; 
run;

proc print data=rep.toto;
run;

/*Créer tableaux données*/ 
/* Tableau 1*/
PROC TABULATE DATA=rep.rugby;
CLASS annee;
VAR taille poids age ;
TABLE annee, (MEAN="Moyenne" MEDIAN="Médiane")*(taille poids age);
RUN;


/* Tableau 2*/
PROC TABULATE DATA=rep.rugby;
CLASS annee poste;
VAR taille poids age ;
TABLE poste*annee, (taille poids age)*(MEAN="Moyenne" STD="Ecart type");
where poste in ("PI","2L","CE","AI");
RUN;

/*Créer une table avec 30 réalisations des 12 var aléa*/ 
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
proc print data=toto;
run;

/*Nouvelle var : moyenne des 12 vars*/
data toto;
set toto;
moy=x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12;
run;
proc print data=toto;
run;

/*Histogramme de la moyenne*/
proc univariate data=toto;
histogram moy;
run;

/*Test de normalité*/
proc univariate data=toto normal;
var moy;
run;

/*Création table avec var année, club, taille, poids pour les joueurs mesurant + de 185 ou avec + de28 ans */
PROC SQL;
   CREATE TABLE rep.riri AS 
      SELECT annee,club,taille,poids
      FROM rep.rugby
      WHERE taille > 185 or age = 28;
run;
proc print data=rep.riri;
run;

/*Création table avec var année, club, taille, poids pour les joueurs poids sup à la moyenne*/
PROC SQL;
   CREATE TABLE rep.fifi AS 
      SELECT annee,club,taille,poids, avg(poids) as poidsmoyen
      FROM rep.rugby
      having poids>poidsmoyen
      ;
run;
proc print data=rep.fifi;
run;
