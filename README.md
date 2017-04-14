La d�duplication mais qu'est-ce que c'est que �a ?
Alors ce n'est pas de la magie noire, non non pas du tout. C'est juste une technique qui permet de pouvoir gagner de la place sur un disque dur et qui permet donc th�oriquement de pouvoir stocker plus que �a contenance. Aucune perte de performance n'est � pr�voir contrairement � la compression.

Alors comment �a marche ?
C'est assez simple. Parmi tous les fichiers pr�sents sur votre disque dur, certains fichiers auront des s�quences de donn�es identiques. Et donc pourquoi les avoir plusieurs fois sur le disque dur alors qu'une seule fois suffit.

Pour faire simple voici un petit sch�ma :

![alt tag](https://cloud.githubusercontent.com/assets/27426117/25043710/2528e384-2122-11e7-9d9d-660205ce24e5.png)

Les s�quences identiques sont donc gard�es une seule fois et ainsi un gain de place peut-�tre obtenu.

D'apr�s la documentation Microsoft voici le gain de place que vous pouvez obtenir par rapport aux types de donn�es :

![alt tag](https://cloud.githubusercontent.com/assets/27426117/25043719/4279271e-2122-11e7-82ca-18afb0fa51ca.png)

Bon ok c'est bien beau tout �a mais pourquoi je n'ai jamais trouv� l'option sur mon Windows 10 tout beau !?
Tout simplement car cette option n'est disponible que sur la version Serveur...

Mais des petits malins se sont amus�s � extraire les biblioth�ques n�cessaires afin de rendre tout ceci possible sur notre petit Windows 10. Sous Linux les utilisateurs peuvent faire de m�me via les syst�mes de fichiers ZFS et BTRFS.

Jusque l� tout va bien c'est facile. Mais une fois install�, seule la ligne de commande permet d'en profiter... �a commence � faire beaucoup pour ce super outil magique.

Alors comme j'avais envie de m'amuser un peu et que je suis sympa (quoi j'ai le droit de me lancer des fleurs :D), j'ai d�velopp� une interface graphique pour piloter tout �a.

Voici un petit aper�u :

![alt tag](https://cloud.githubusercontent.com/assets/27426117/25043738/6ad7510e-2122-11e7-8600-5ca2e62b33e4.JPG)

Pour l'utiliser rien de plus simple, on ex�cute le logiciel en tant qu'administrateur. Si les pr�requis ne sont pas pr�sents sur votre PC ils seront install�s lors du 1er lancement, donc pas d'inqui�tude si la 1�re fois l'interface met un peu de temps avant d'appara�tre. Celle-ci vous affiche ensuite toutes les partitions � l'exception de celle h�bergeant l'OS (en g�n�ral le C:) car cette option ne peut-�tre appliqu�e sur la partition syst�me.

Ensuite vous avez 3 boutons :
- Actualiser : qui permet d'actualiser l'affichage.
- Optimiser : qui permet apr�s avoir s�lectionn� une partition de lancer le processus de d�duplication. Si l'option n'est pas encore active sur la partition, celle-ci est activ�e si et seulement si l'espace libre �quivaut � 10% de la taille totale de la partition et ensuite le processus est ex�cut�. Celui-ci peut durer plus ou moins longtemps en fonction du volume de donn�es � traiter.
- Nettoyer : qui permet de faire un petit nettoyage par exemple apr�s la suppression de donn�es afin de r�cup�rer de la place si cela est possible. Cela permet aussi de v�rifier l'int�grit� des donn�es de d�duplication.
- D�sactiver : qui permet de d�sactiver la d�duplication sur la partition s�lectionn�e si et seulement si l'espace disque libre est suffisant. Il doit rester en espace libre la place gagn�e par la d�duplication + une marge de 10%. Si lors de la proc�dure cela ne suffit pas, le travail se mettra en attente et il faudra simplement faire de la place.

Dans une prochaine version je rajouterai un bouton pour d�sactiver la d�duplication sur le volume s�lectionn�.

ATTENTION : cette version est uniquement compatible avec la version Windows 10 Creators Update.

ATTENTION : un volume utilisant la d�duplication ne pourra pas �tre utilis� depuis un PC ne disposant pas des outils de d�duplication.