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
