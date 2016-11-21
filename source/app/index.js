import '../index.html';
import '../styles/app.scss';

import Game from './class/Game';

require('babel-runtime/core-js/promise').default = require('bluebird');

window.onload = new Game();
