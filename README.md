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
    
#### Run the game

    prolog -l backend/source/main.pl    # launch the server
    -> init.
    -> server(8000).
    
    # in another console
    npm start   # launch the client
    
You can then access the game at `http://localhost:8080`