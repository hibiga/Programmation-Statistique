LIBNAME rep "/folders/myfolders/TP_2" ;

/*EXERCICE 1*/
/*Importer données excel*/
data rep.caf;
infile '/folders/myfolders/TP_2/caf2006.csv'
dlm=';'
firstobs=2
missover dsd termstr=CRLF; 
input Ident$	ACT_ALLOC$	ACT_CON$	age2006_alloc	sexe_alloc	age2006_conj	annnen1	annnen2	annnen3	annnen4	annnen5	annnen6	annnen7	RMI	dtdemrmi	C_ss_enf	C_av_enf	I_ss_enf	I_av_enf	nbenf;
informat dtdemrmi ddmmyy10.;
format dtdemrmi ddmmyy10.;
run;

/*Vérifier résultats*/
proc print data = rep.caf; 
run; 

proc contents data = rep.caf; 
run;

/*Si on omet informat et format :*/
informat dtdemrmi ddmmyy10. : les dates ne s’affichent plus car elles ne sont pas dans le bon format 
format dtdemrmi ddmmyy10. : l’écriture des dates ne sont pas faites correctement, il manque les « / »

/*EXERCICE 2*/
/*Créer variables*/
data rep.caf; 
set rep.caf; 
if annnen1 <> 0 then 
Agenf1 = 2006-annnen1;
run;  

data rep.caf; 
set rep.caf; 
if C_ss_enf = 1 then 
Sitfam = "Couple sans enfant"; 
else if C_av_enf = 1 then  
Sitfam = "Couple avec enfant"; 
else if I_av_enf = 1 then 
Sitfam = "isolé avec enfant"; 
else if I_ss_enf = 1 then 
Sitfam = "isolé sans enfant"; 
run; 

data rep.caf; 
set rep.caf; 
if dtdemrmi <> 0 then
Anc_an = 2006-Year(dtdemrmi); 
run; 

data rep.caf; 
set rep.caf; 
if dtdemrmi <> 0 then
Anc_mois = 12*Anc_an + (12-Month(dtdemrmi)); 
run;

/*pour accéder à l’année dans une date : Year(nom var) et pour le mois : Month(nom var)*/

proc print data = rep.caf; 
run;

/*Créer tableau*/
data rep.rmi2006sas7bdat; 
set rep.caf; 
if RMI = 0 then delete;
run; 
proc print data=rep.rmi2006sas7bdat; 
run; 

/*Création formats : ils se créent indépendamment de la table dans laquelle ils sont censés s’appliquer*/
proc format; 
value sexe 1="Homme" 2="Femme" ; 
run; 
proc print data = rep.caf; 
format sexe_alloc sexe.;
run;

proc format; 
value id 1="Oui" 0="Non" ; 
run; 
proc print data = rep.caf; 
format C_ss_enf C_av_enf I_ss_enf I_av_enf id.;
run;

proc format; 
value enf 0="pas d'enfant" 1="un enfant" 2="2 enfants au moins"; 
run; 
proc print data = rep.caf; 
format nbenf enf.;
run; 

prof format ; 
value fam "Couple sans enfant"="Couple" "Couple avec enfant"="Couple" "Isolé sans enfant"="Isolé" "Isolé avec enfant"="Isolé";
run ; 

/*Utilisation des formats*/
proc print data=sas.RMI2006;
FORMAT RMI id. NBENF ENF. SITFAM FAM.  sexe_alloc SEXE.;
RUN;

/*On affecte définitivement :*/
DATA sas.RMI2006;
set sas.RMI2006;
FORMAT RMI OUINON. NBENF ENF. SITFAM FAM.  sexe_alloc SEXE.;
RUN;

/*On affiche sans le format Homme/Femme :*/
proc print data=sas.RMI2006;
FORMAT sexe_alloc;
RUN;

/*PARTIE 2 _ EXERCICE 1*/ 
/*Créer le tableau*/
data dates;
length produit $ 10;
informat date DDMMYY10.; 
input produit $ date at1 at2 at3 at4;
cards;
tal863510v 15/12/2010 5 8 11 4
tal863511v 17/01/2011 3 2 3 2
tal863512v 19/01/2011 8 12 8 12
tar248621d 22/01/2011 14 2 11 8
;
run;

proc print data=dates;
run;

data dates;
set dates;
nb_jour_total=at1+at2+at3+at4;
date_finale=date+nb_jour_total;
run;

proc print data=dates;
format date DDMMYY10.;
format date_finale DDMMYY10.;
run;

/*PARTIE 2 _ EXERICE 2*/ 
/*Créer table sas*/
DATA test;
  INPUT X;
  CARDS; 
   1
   5
   4
   2
   6
   9
   8
;
RUN;

proc print data=test;
run;

/*Créer nouvelle variable*/
Data test_bis;
set test;
retain Y 0;
Y=X+Y;
run;
proc print data=test_bis;
run;

/*Somme successives de X*/ 
Data test_ter;
set test;
retain Y 0;
Y=max(X,Y);
run;

/*Maximas successifs de X*/
Data test_quad;
set test;
retain Y 0;
retain Z 0;
Y=X-Z;
Z=X;
run;
