/* eslint-disable import/no-extraneous-dependencies, import/extensions, import/no-unresolved */
import { Bitmap, Shape } from 'EaselJS';
import config from '../config';
import utils from '../modules/utils';
import Game from './Game';
import Player from './Player';

/* Game constants */
const GRID_MARGIN = 50;
const GRID_STROKE_WIDTH = 5;
const PLAYER_NAMES = [
  'Jarvis',
  'xXxRaptorxXx',
  'BigBlue',
  'Unicoooorn',
];

/** MainMenu showing game menu */
export default class MainScene {
  /**
   * Calling init function
   */
  constructor() {
    this.players = [];
    this.init();
  }

  /**
   * Create mainmenu container with title object
   */
  init() {
    this.ctr = utils.drawCtr();

    this.bg = new Bitmap(Game.IMAGES.mainSceneBg);
    const scale = Math.max(
      config.canvas.width / this.bg.image.width,
      config.canvas.height / this.bg.image.height);
    this.bg.scaleX = this.bg.scaleY = scale;
    this.ctr.addChild(this.bg);

    const boardSize = 10;
    const p1X = 1;
    const p1Y = 1;
    const p2X = 10;
    const p2Y = 10;
    const p1AI = 'AI_FOLLOWER';
    const p2AI = 'AI_RANDOM2';

    const startURL = `http://localhost:8000/start?boardSize=${boardSize}&p1X=${p1X}&p1Y=${p1Y}&p2X=${p2X}&p2Y=${p2Y}&p1AI=${p1AI}&p2AI=${p2AI}`;

    // Init the server connection
    utils.request({
      url: startURL,
      method: 'GET',
    }, (err, res) => {
      if (res.statusCode !== 204) window.console.error('Can\'t reach the Prolog server :(');
      else {
        /*
          Should contain:
          size: int
          heads: array, contains each player object
            x: int -> starting at 1
            y: int -> starting at 1
         */
        this.setupBoard(boardSize, boardSize);

        console.log(`Player added: ${PLAYER_NAMES[0]}.`);
        const player1 = new Player(PLAYER_NAMES[0],
            this.cellSize,
            p1X,
            p1Y,
            );

        this.players.push(player1);
        this.board.addChild(player1);

        console.log(`Player added: ${PLAYER_NAMES[1]}.`);
        const player2 = new Player(PLAYER_NAMES[1],
            this.cellSize,
            p2X,
            p2Y,
            );

        this.players.push(player2);
        this.board.addChild(player2);
      }

      Game.STAGE.addChild(this.ctr);

      // Add the "press enter" message
      this.beginOnEnter();
    });
  }

  beginOnEnter() {
    const text = utils.drawTextShape(
      0,
      0,
      config.canvas.width,
      100,
      '#F7F7F7',
      'Press Enter to start the game',
      'black',
      '50px Ubuntu',
    );
    text.alpha = 0.8;

    this.ctr.addChild(text);
    const callback = (event) => {
      if (event.keyCode === 13) {
        window.console.log('Game started.');
        this.ctr.removeChild(text);
        this.fetchNextMove();
        window.removeEventListener('keypress', callback);
        return false; // returning false will prevent the event from bubbling up.
      }

      return true;
    };
    window.addEventListener('keypress', callback);
  }

  /**
   * Draw the game grid on the scene
   * @param rows  the number of row of the grid
   * @param cols  the number of cols of the grid
   */
  setupBoard(rows, cols) {
    const grid = new Shape();

    // Compute the size of a cell
    this.cellSize =
      (Math.min(config.canvas.width, config.canvas.height) - GRID_MARGIN) / Math.max(rows, cols);

    this.board = utils.drawCtr(
      (config.canvas.width - (cols * this.cellSize)) / 2,
      (config.canvas.height - (rows * this.cellSize)) / 2);
    this.board.width = cols * this.cellSize;
    this.board.height = rows * this.cellSize;

    // Draw the grid
    grid.graphics.setStrokeStyle(GRID_STROKE_WIDTH).beginStroke('#fff');
    grid.alpha = 0.3;
    grid.graphics.rect(0, 0, this.board.width, this.board.height);

    for (let col = 1; col < cols; ++col) {
      grid.graphics.moveTo(this.cellSize * col, 0);
      grid.graphics.lineTo(this.cellSize * col, this.board.height);
    }

    for (let row = 1; row < rows; ++row) {
      grid.graphics.moveTo(0, this.cellSize * row);
      grid.graphics.lineTo(this.board.width, this.cellSize * row);
    }

    this.board.addChild(grid);
    this.ctr.addChild(this.board);
  }

  /**
   * Fetch from the server the next move of each player
   */
  fetchNextMove() {
    utils.request({
      url: 'http://localhost:8000/playOnce',
      method: 'GET',
      json: true,
      responseType: 'json',
    }, (err, res, response) => {
      if (response == null) window.console.error('Can\'t reach the Prolog server :(');
      else if (response.state === 'CONTINUE') {
        this.players[0].updatePosition(response.p1X, response.p1Y);
        this.players[1].updatePosition(response.p2X, response.p2Y);

        /*
        for (let i = 0; i < response.heads.length; ++i) {
          this.players[i].updatePosition(response.heads[i].x, response.heads[i].y);
        }
        */

        // Fetch the next move
        this.fetchNextMove();
      } else {
        console.log(`Game ended: ${response.state}`);
      }
    });
  }

}
