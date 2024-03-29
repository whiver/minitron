# minitron
A Tron-like game demo that make artificial intelligences fight against each other.

### Build the game
#### Prerequisites
You must have `Node`, `npm`, `Bower`, `SWI Prolog` and `webpack-dev-server` installed. If not,
install Node, SWI Prolog and run this command:

    npm i -g bower webpack-dev-server
    
#### Dependencies
To download the dependencies of the project:

    npm i
    bower install

### Run the game
To run the game, open a console into the project's folder and type the following commands:

    // Launch the Prolog server
    prolog -l backend/source/main.pl
    > serve(8000).
    
    // In another console, launch the Web server
    npm start
    
You can then access the game at `http://localhost:8080`.

## Développement
### Démarrer le jeu
#### Depuis la console Prolog
```
prolog -l backend/source/main.pl
start(BoardSize, [P1X, P1Y], [P2X, P2Y], P1AI, P2AI).
    - BoardSize : Taille d'un côté du plateau de jeu
    - [P1X, P1Y] : Coordonnées de la position initiale du joueur 1 (les indices commencent à 1)
    - [P2X, P2Y] : Coordonnées de la position initiale du joueur 2 (les indices commencent à 1)
    - P1AI : IA du joueur 1 (ex : 'AI_FOLLOWER', 'AI_RANDOM2')
    - P2AI : IA du joueur 2 (ex : 'AI_FOLLOWER', 'AI_RANDOM2')
```
    
#### Depuis le Web (HTTP)
```
//Démarrer le serveur Prolog
prolog -l backend/source/main.pl
server(Port).
    - Port : numéro de port sur lequel le serveur va écouter
    
Dans un navigateur (ou wget ou autre) : 
http://localhost:Port/start?boardSize=BoarSize&p1X=P1X&p1Y=P1Y&p2X=P2X&p2Y=P2Y&p1AI=AI_FOLLOWER&p2AI=AI_RANDOM2
    - BoardSize : Taille d'un côté du plateau de jeu
    - P1X : Position initiale en X du joueur 1 (commence à 1)
    - P1Y : Position initiale en Y du joueur 2 (commence à 1)
    - P2X : Position initiale en X du joueur 2 (commence à 1) => Par défaut prend la valeur BoardSize
    - P2Y : Position initiale en Y du joueur 2 (commence à 2) => Par défaut prend la valeur BoardSize
    - P1AI : IA du joueur 1 (ex : AI_FOLLOWER, AI_RANDOM2)
    - P2AI : IA du joueur 2 (ex : AI_FOLLOWER, AI_RANDOM2)

Ne retourne rien (Status 204 No Content)
```

### Jouer un coup
#### Depuis la console Prolog
```
playOnce.
```
#### Depuis le Web (HTTP)
```
http://localhost:Port/playOnce

Retourne du JSON sous la forme :
{
    "state":STATE,
    "p1X":P1X,
    "p1Y":P1Y,
    "p2X":P2X,
    "p2Y":P2Y
}

- STATE : État résultant du coup joué par les deux joueurs. Valeurs possibles:
    * DRAW : Match nul
    * WINNER1 : Le joueur 1 a gagné
    * WINNER2 : Le joueur 2 a gagné
    * CONTINUE : Aucun joueur n'a gagné/perdu => La partie continue
- P1X : Nouvelle position en X de la tête du joueur 1
- P1Y : Nouvelle position en Y de la tête du joueur 1
- P2X : Nouvelle position en X de la tête du joueur 2
- P2Y : Nouvelle position en Y de la tête du joueur 2
```

### Jouer automatiquement
```
playAuto(TimeStep, PrintBoard, Winner).
- TimeStep : Intervale de temps en secondes qui va séparer deux itérations successives.
- PrintBoard : Booleen autorisant ou non les writeln.
- Winner : Var qui recevra le gagnant à la fin de la partie.
```
