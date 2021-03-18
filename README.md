# MoBiPA

<br/>

## Le Sujet
<br/>
Ceci est un projet de fin d'études réalisé par deux étudiants en 5ème année d'ingénierie, filière Informatique à Polytech Grenoble.
<br/>
<br/>

*(Insérer nos photos avec noms)*

<br/>
<p>En collaboration avec le personnel de l'UGA, le but était de créer une application de covoiturage solidaire pour la ville de La Mure permettant aux personnes à mobilité réduite ou âgées de se déplacer plus simplement. Ces personnes peuvent télécharger l'application, demander un déplacement et des conducteurs bénévoles peuvent répondre à ces requêtes après avoir téléchargé l'application également.</p>

<p>Cette application est disponible sur Android, iOS et on propose même une solution Web pour ceux qui ne possèdent pas de smartphone. Le service est 100% gratuit et requiert juste la création d'un compte avec son adresse mail.</p>

<p>L'essentiel de cette application est qu'elle soit intuitive sans trop d'informations, il est important de se rappeler que des personnes âgées ne sont pas forcément très à l'aise avec les nouvelles technologies. A part ça, nous n'avions pas trop de contraintes et nous avons pu laisser parler notre créativité et compétences pour choisir les technologies et construire les interfaces. Nous en parlerons plus en détails dans la suite.</p>
<br/>
<br/>

## Techniques

<br/>
Pour développer notre application, nous avons choisi d'utiliser Flutter.

<img width="200" alt="flutter" src="https://user-images.githubusercontent.com/46927019/111627534-6ff20e80-87ef-11eb-97a7-81726d6c530c.png">

Nous avons fait le choix d'utiliser ce langage de programmation en particulier car il correspondait le plus à ce que l'on voulait atteindre, à savoir une application disponible sur toutes les plateformes, que ce soit Android ou IOS et qui ai aussi une alternative sur le web.
De ce fait, Flutter nous semblait être le choix le plus adéquat car il nous permet grâce à un seul code généré de pouvoir obtenir ces 3 alternatives en même temps.
De plus, Flutter a une documentation assez riche sur internet et il est très facile à prendre en main même pour des personnes qui n'ont jamais utilisé Dart au par avant. Ajouté à cela le fait qu'un grand catalogue d'extensions sont disponibles gratuitement et utilisables sans forcément altérer  le code précédemment généré.
<br>


Concernant le stockage de nos données, nous avons choisi d'utiliser FireBase.
<img width="200" alt="flutter" src="https://firebase.google.com/images/brand-guidelines/logo-standard.png">
<br>
Firebase est une plateforme développée par Google comme Flutter afin de pouvoir créer des applications Web et Mobiles.
De part sa compatibilité avec Flutter, nous avons choisit de l'utiliser comme base de donnée distante grâce au service **Cloud Firebase**.
Dans cette base de données nous avons divisé nos stockages en 3 parties :

 -  Partie Conducteur
	 -  
	 - Nous aurons ici tous les conducteurs qui se seront inscrit sur l'application en tant que conducteurs, ils auront tous un ID bien définit pour eux,  de plus, chaque conducteur aura un certain nombre de champs spécifiques :
		 - Prénom
		 - Nom de famille
		 - Numéro de téléphone
		 -  Les trajets en cours
 - Partie Utilisateur
	 -
	 - Tous les passagers sont disponibles ici, ils ont chacun un identifiant propre mais aussi des champs bien spécifiques:
		
		 - Nom de famille
		 - Prénom
		 - Historique de touts les trajets faits
		 - Numéro de téléphone

 
 - Partie Requests
	 - 
	 - Chaque requête a un identifiant propre mais aussi une serie de champs qui nous aideront pour le bon fonctionnement du trajet :
		 - La Date
		 - Les identifiants de l'utilisateur et du conducteur
		 - Le lieu de départ ainsi que ses coordonnées géographiques
		 - Le lieu d'arrivé ainsi que ses coordonnées géographiques
		 - Les coordonnées géographiques de l'utilisateur et du conducteur
		 - Le statut de la commande : Ouvert ou Fermé


Ces dispositions ainsi que ces techniques nous ont permis d'agencer notre base de données.
<br>
Concernant les IDE que nous avons utilisé dans notre projet, nous avions commencé a coder sur Visual Studio   
<br><img width="200" alt="vscode" src="https://framalibre.org/sites/default/files/styles/thumbnail/public/leslogos/Visual_Studio_Code_1.18_icon.png?itok=smeMcds3">

Cet IDE nous a été utile au début car il offre une interface assez intéressante pour la gestion des dépendances de Flutter, seulement, on se retrouve assez limité au niveau des fonctionnalités et surtout au niveau de l’aperçu du code.

Nous avons donc décidé de changer d'IDE et de passer sur Android Studio :
<br>
<img width="200" alt="androidstudi" src="https://2.bp.blogspot.com/-tzm1twY_ENM/XlCRuI0ZkRI/AAAAAAAAOso/BmNOUANXWxwc5vwslNw3WpjrDlgs9PuwQCLcBGAsYHQ/s1600/pasted%2Bimage%2B0.png">

N'ayant pas tous les deux un téléphone Android, Android Studio offre la possibilité d'utiliser un émulateur de téléphone sous Android.
De ce fait, les tests et l'implémentation de nouvelles fonctionnalités se font plus rapidement.
## Architecture technique
Concernant notre architecture, nous avons opté pour l'architecture suivante :
<img width="900" alt="androidstudi" src="https://imgur.com/9aLlv9l.png">

## Réalisations techniques
Durant ce projet nous avons réalisé les fonctionnalités techniques suivantes : 

 -    Base de donnée distante Firebase
-   Possibilité de s’inscrire et de se connecter en tant que passager et en tant que conducteur
-   Affichage de tous les trajets disponibles pour un conducteur
-   Prise en charge d’un trajet par le conducteur
-   Création d’un trajet par le passager
-   Possibilité de changer ses données personnelles
-   Interface de contact
-   Possibilité de choisir un lieu de rencontre spécifique
 -   Interface responsive
-   Possibilité de choisir avec une carte ou une adresse les lieux de rencontre
-   Possibilité d’avoir une photo de profil pour chaque utilisateur
-   Google Maps avec tracé du trajet

## Gestion de projet
Concernant notre gestion de projet, vu que l'un d'entre nous était déjà familier avec les technologies que nous avons précisé précédemment, nous avons opté lors du début du projet pour du **Pair Programming**.
Cette approche nous procuré énormément d'avantages comme le fait de pouvoir s'approprier les outils plus rapidement, le fait de pouvoir s'adapter à un nouveau environnement de travail et finalement de pouvoir apprendre à coder dans un langage inconnu assez rapidement.

Nous nous sommes par la suite organiser de telle sorte que notre projet puisse se diviser en 3 grandes étapes : 

 - Créations des outils de travail
 
	Configuration de la base de donnée
	Installation de Flutter sur les machines
	
 - Création des fonctionnalités principales de l'application

	 Possibilité de créer un trajet
	 Possibilité de prendre en charge un trajet 
	 Interfaces différentes pour les conducteurs et pour les utilisateurs
	 Pouvoir paramétrer son compte
	 Pouvoir se déconnecter
	 Pouvoir s'inscrire
	 Pouvoir se connecter
 - Ajout de détails dans l'application et rattraper un éventuel retard
 
	 Refonte totale de l'interface graphique de l'application
	 Generation de l'APK
	 Cacher les clés API 
	 


## Outils
 Concernant les outils d’organisation, nous avons utilisé l'outil de gestion de projet de Git.
 
 ![Capture du 2021-03-18 18-44-33](https://user-images.githubusercontent.com/46927019/111672477-4b5f5c00-881a-11eb-8767-8faf661e1822.png)


Cela a ses avantages comme par exemple, une utilisation simplifiée, nos commits, nos pull request et nos issues sont automatiques organisées et triées en 4 catégories : 

 - To Do
 - In Progress
 - To Review
 - Done
Cela nous permet de garder une trace de tout ce que l'on fait, sans pour autant s'encombrer avec un Trello en parallèle de notre Git.

En plus de Git, afin de pouvoir communiquer l'un avec l'autre, nous avons aussi utilisé Discord
 <img width="200" alt="discord" src=" https://cdn.icon-icons.com/icons2/2108/PNG/512/discord_icon_130958.png">

# Métriques logicielles
<br/>
Au niveau de la répartition des tâches nous sommes à peu près sur du 50/50. Comme nous ne sommes que deux et que nous avons une très bonne cohésion (ce qui est essentiel dans un groupe de travail) nous avons pu avancer à notre propre rythme sans conflit. On savait que chacun fournissait le travail requis et cela a porté ses fruits. On peut le voir sur la répartition du travail :
<br/>

# Lignes de codes

Nous sommes à 2888 de lignes codées (nous ne comptons pas les lignes générées par Flutter).
Au niveau des langages utilisées nous sommes à 99.5% de Dart et le reste c'est du généré, essentiellement du JSON, Java et du XML.
<br/>

Là dessus, nous sommes à 50.82% de lignes de codes pour Ali et 49.18% pour William. Si nous prenons en compte le nombre de commits, nous sommes à 43.10% pour Ali et 56.90% pour William.


## Conclusion
## Transparent expliquant la démonstration
