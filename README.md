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

#### Démarrer la partie
    # Depuis la console Prolog
    prolog -l backend/source/main.pl
    start(BoardSize, [P1X, P1Y], [P2X, P2Y], P1AI, P2AI).
        - BoardSize : Taille d'un côté du plateau de jeu
        - [P1X, P1Y] : Coordonnées de la position initiale du joueur 1 (les indices commencent à 1)
        - [P2X, P2Y] : Coordonnées de la position initiale du joueur 2 (les indices commencent à 1)
        - P1AI : IA du joueur 1 (ex : 'AI_FOLLOWER', 'AI_RANDOM2')
        - P2AI : IA du joueur 2 (ex : 'AI_FOLLOWER', 'AI_RANDOM2')
    
    # Depuis le Web (HTTP)
    prolog -l backend/source/main.pl
    server(Port).
        - Port : numéro de port sur lequel le serveur va écouter
    Dans un navigateur (ou wget ou autre) : http://localhost:Port/start?boardSize=BoarSize&p1X=P1X&p1Y=P1Y&p2X=P2X&p2Y=P2Y&p1AI=AI_FOLLOWER&p2AI=AI_RANDOM2
        - BoardSize : Taille d'un côté du plateau de jeu
        - P1X : Position initiale en X du joueur 1 (commence à 1)
        - P1Y : Position initiale en Y du joueur 2 (commence à 1)
        - P2X : Position initiale en X du joueur 2 (commence à 1) => Par défaut prend la valeur BoardSize
        - P2Y : Position initiale en Y du joueur 2 (commence à 2) => Par défaut prend la valeur BoardSize
        - P1AI : IA du joueur 1 (ex : AI_FOLLOWER', AI_RANDOM2)
        - P2AI : IA du joueur 2 (ex : AI_FOLLOWER', AI_RANDOM2)
        
        Ne retourne rien (Status 204 No Content)

#### Jouer un coup
    # Depuis la console Prolog
    playOnce.
    
    # Depuis le Web (HTTP)
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
                - DRAW : Match nul
                - WINNER1 : Le joueur 1 a gagné
                - WINNER2 : Le joueur 2 a gagné
                - CONTINUE : Aucun joueur n'a gagné/perdu => La partie continue
            - P1X : Nouvelle position en X de la tête du joueur 1
            - P1Y : Nouvelle position en Y de la tête du joueur 1
            - P2X : Nouvelle position en X de la tête du joueur 2
            - P2Y : Nouvelle position en Y de la tête du joueur 2

#### Jouer automatiquement (disponible uniquement pour la console Prolog)
    playAuto(TimeStep).
        - TimeStep : Intervale de temps en secondes qui va séparer deux itérations successives.

#### Interface Web
    # Dans une console de commande
    npm start
    
    PUIS
    
    # Dans un navigateur Web
    http://localhost:8080
