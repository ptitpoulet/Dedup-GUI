La déduplication mais qu'est-ce que c'est que ça ?
Alors ce n'est pas de la magie noire, non non pas du tout. C'est juste une technique qui permet de pouvoir gagner de la place sur un disque dur et qui permet donc théoriquement de pouvoir stocker plus que ça contenance. Aucune perte de performance n'est à prévoir contrairement à la compression.

Alors comment ça marche ?
C'est assez simple. Parmi tous les fichiers présents sur votre disque dur, certains fichiers auront des séquences de données identiques. Et donc pourquoi les avoir plusieurs fois sur le disque dur alors qu'une seule fois suffit.

Pour faire simple voici un petit schéma :

![alt tag](https://cloud.githubusercontent.com/assets/27426117/25043710/2528e384-2122-11e7-9d9d-660205ce24e5.png)

Les séquences identiques sont donc gardées une seule fois et ainsi un gain de place peut-être obtenu.

D'après la documentation Microsoft voici le gain de place que vous pouvez obtenir par rapport aux types de données :

![alt tag](https://cloud.githubusercontent.com/assets/27426117/25043719/4279271e-2122-11e7-82ca-18afb0fa51ca.png)

Bon ok c'est bien beau tout ça mais pourquoi je n'ai jamais trouvé l'option sur mon Windows 10 tout beau !?
Tout simplement car cette option n'est disponible que sur la version Serveur...

Mais des petits malins se sont amusés à extraire les bibliothèques nécessaires afin de rendre tout ceci possible sur notre petit Windows 10. Sous Linux les utilisateurs peuvent faire de même via les systèmes de fichiers ZFS et BTRFS.

Jusque là tout va bien c'est facile. Mais une fois installé, seule la ligne de commande permet d'en profiter... Ça commence à faire beaucoup pour ce super outil magique.

Alors comme j'avais envie de m'amuser un peu et que je suis sympa (quoi j'ai le droit de me lancer des fleurs :D), j'ai développé une interface graphique pour piloter tout ça.

Voici un petit aperçu :

![alt tag](https://cloud.githubusercontent.com/assets/27426117/25043738/6ad7510e-2122-11e7-8600-5ca2e62b33e4.JPG)

Pour l'utiliser rien de plus simple, on exécute le logiciel en tant qu'administrateur. Si les prérequis ne sont pas présents sur votre PC ils seront installés lors du 1er lancement, donc pas d'inquiétude si la 1ère fois l'interface met un peu de temps avant d'apparaître. Celle-ci vous affiche ensuite toutes les partitions à l'exception de celle hébergeant l'OS (en général le C:) car cette option ne peut-être appliquée sur la partition système.

Ensuite vous avez 3 boutons :
- Actualiser : qui permet d'actualiser l'affichage.
- Optimiser : qui permet après avoir sélectionné une partition de lancer le processus de déduplication. Si l'option n'est pas encore active sur la partition, celle-ci est activée si et seulement si l'espace libre équivaut à 10% de la taille totale de la partition et ensuite le processus est exécuté. Celui-ci peut durer plus ou moins longtemps en fonction du volume de données à traiter.
- Nettoyer : qui permet de faire un petit nettoyage par exemple après la suppression de données afin de récupérer de la place si cela est possible. Cela permet aussi de vérifier l'intégrité des données de déduplication.
- Désactiver : qui permet de désactiver la déduplication sur la partition sélectionnée si et seulement si l'espace disque libre est suffisant. Il doit rester en espace libre la place gagnée par la déduplication + une marge de 10%. Si lors de la procédure cela ne suffit pas, le travail se mettra en attente et il faudra simplement faire de la place.

Dans une prochaine version je rajouterai un bouton pour désactiver la déduplication sur le volume sélectionné.

ATTENTION : cette version est uniquement compatible avec la version Windows 10 Creators Update.

ATTENTION : un volume utilisant la déduplication ne pourra pas être utilisé depuis un PC ne disposant pas des outils de déduplication.