# games-crisp-game-lib

## これはなに？
crisp-game-lib を使うサンプル

## DEMO1
http://cat2151.github.io/games-crisp-game-lib/?hello
- クリックすると音が1回鳴ります
- [ソースコード _template をコピーして1行追記したもの](https://github.com/cat2151/games-crisp-game-lib/blob/main/docs/hello/main.js)

## DEMO2
http://cat2151.github.io/games-crisp-game-lib/?hello2
- 構成のサンプル
    - 1ディレクトリに1ゲーム

## コードのサンプル crisp-game-lib
- それぞれ、貼るだけで動きます。
- サンプルなのでスコアやゲーム駆け引きはあったりなかったり。
- 公式のほうが詳しいです。
- 書き換えて遊びましょう。
- コードブロックの右上のコピーボタンを押すとクリップボードにコピーできます。
  - それと `docs\chromeClipboardSaver.bat` を組み合わせれば、
    - クリックだけで各種サンプルをブラウザで動作確認できます。
    - VS Codeでその場で編集もできます。
  - 方法は：
    - `npm run watch_games` します。
    - VS Codeでmain.jsを開いておきます。
    - `docs\chromeClipboardSaver.bat` を実行し、main.jsを選びます。
    - ブラウザでコードブロックの右上のコピーボタンをクリックします。
    - VS Codeに反映されたことを確認します。
    - ブラウザに反映されたことを確認します。
    - VS Codeで編集します。
    - ブラウザに反映されたことを確認します。

### 描画
- color と box
```JavaScript
function update() {
  color("red");
  box(20, 20, 15, 20);
  color("green");
  box(40, 40, 15, 20);
}
```
- box
```JavaScript
function update() {
  box(50, 50, 60, 60);
}
```
- rect
```JavaScript
function update() {
  rect(50, 50, 40, 40);
}
```
- box と rect
```JavaScript
function update() {
  color("red");
  box( 50, 50, 25, 25);
  color("green");
  rect(50, 50, 25, 25);
}
```
- bar
```JavaScript
function update() {
  bar(50, 50, 60, 3, PI / 8, 0.5);
}
```
- bar 回転
```JavaScript
function update() {
  let t1= (ticks % 60) / 60;
  let t2= ((ticks / 60) % 20) / 20;
  bar(50, 50, 20, 3, PI * 2 * t1, t2);
}
```
- line
```JavaScript
function update() {
  line(50, 50, 90, 90);
}
```

- line 動く
```JavaScript
function update() {
  let l = ticks % 100;
  line(20, l, l, 30);
}
```
- arc
```JavaScript
function update() {
  arc(50, 50, 50, 3, PI / 4, PI);
}
```

- text
```JavaScript
function update() {
  text("hello", 33, 40);
}
```
- char
```JavaScript
characters = [
  `
rrrrrr
rCrCrr
rCrCrr
rrrrrr
rrCrrr
rrrrrr
`];
function update() {
  char("a", 33, 40);
}
```

- 描画まとめ
```JavaScript
function update() {
  color("red");
  box(      20, 20, 15, 20);
  rect(     70, 20, 20, 25);
  bar(      20, 70, 18,  5, 0.7, 0.5);
  line(     70, 70, 90, 80);
  arc(      30, 60, 20,  5, 0.1, 1.5);
  text("a", 10, 20);
  char("a", 30, 40);
}
```

- 描画まとめ 動く
```JavaScript
function update() {
  color("red");
  let o = (ticks / 20) % 3;
  box(      20 + o, 20, 15, 20);
  rect(     70 - o, 20, 20, 25);
  bar(      20 + o, 70, 18,  5, 0.7, 0.5);
  line(     70 - o, 70, 90, 80);
  arc(      30 + o, 60, 20,  5, 0.1, 1.5);
  text("a", 10 - o, 20);
  char("a", 30 + o, 40);
}
```

- 音
```JavaScript
function update() {
  play("coin");
}
```
- 音
```JavaScript
function update() {
  play("explosion");
}
```
- 音
```JavaScript
function update() {
  play("hit");
}
```
- 音
```JavaScript
function update() {
  play("jump");
}
```
- 音
```JavaScript
function update() {
  play("laser");
}
```
- 音
```JavaScript
function update() {
  play("lucky");
}
```
- 音
```JavaScript
function update() {
  play("powerUp");
}
```
- 音
```JavaScript
function update() {
  play("select");
}
```

- 当たり判定
  - green を動かして yellow を避けろ
```JavaScript
function update() {
  color("yellow");
  box(50, 60, 40, 30);
  color("green");
  if (box(input.pos, 5, 5).isColliding.rect.yellow) {
    end();
  }
}
```

- 当たり判定
  - green を動かし、動く yellow を避けろ
```JavaScript
options = {
  isPlayingBgm: true,
};
function update() {
  color("yellow");
  let o = ticks % 100;
  let s = (difficulty - 1) * 500;
  box(o, o, s, s);
  color("green");
  if (box(input.pos, 5, 5).isColliding.rect.yellow) {
    play("explosion");
    end();
  }
  addScore(1);
}
```
- 解像度 31x19
```JavaScript
options = {
	viewSize: {x: 1 + 6 * 5, y: 1 + 6 * 3},
};
function update() {
  text("hello", 3, 3 + 6 * 1);
  text("world", 3, 3 + 6 * 2);
}
```

- 解像度 640x480
```JavaScript
options = {
	viewSize: {x: 640, y: 480},
};
function update() {
  text("hello", 3, 3 + 6 * 1);
  text("world", 3, 3 + 6 * 2);
}
```

- FizzBuzz風
```JavaScript
function update() {
  let t = Math.floor(ticks / 60);
  let s;
  if (t % 15 === 0) {
    s = "FizzBuzz";
  } else if (t % 3 === 0) {
    s = "Fizz";
  } else if (t % 5 === 0) {
    s = "Buzz";
  } else {
    s = t.toString();
  }
  text(s, 50, 50);
}
```

- 宇宙風味、解像度240x320
```JavaScript
const G = {
	WIDTH: 240,
	HEIGHT: 320
};
options = {
	viewSize: {x: G.WIDTH, y: G.HEIGHT},
  theme: "dark"
};
let stars;
function update() {
  if (!ticks) {
    stars = times(20, () => {
      const posX = rnd(0, G.WIDTH);
      const posY = rnd(0, G.HEIGHT);
      return {
        pos: vec(posX, posY),
        speed: rnd(0.5, 1.0)
      };
    });
  }
  stars.forEach((s) => {
    s.pos.y += s.speed;
    s.pos.wrap(0, G.WIDTH, 0, G.HEIGHT);
    color("light_black");
    box(s.pos, 1);
  });
  bar(G.WIDTH / 2, G.HEIGHT * 0.75, 100, 5, PI * 2 * (ticks % 120) / 120, 0.5);
  text("hello, world!", G.WIDTH / 3, G.HEIGHT / 2);
}
```

- 実験用 ticks と window.performance.now()
  - window.performance.now() は実験用のため例外的に使っているが、実際のゲームではticksを使うべし。でないとリプレイが破綻するはず。
```JavaScript
function update() {
  text(floor(window.performance.now() / (1000 / 60)).toString(), 3, 12);
  text(ticks.toString(), 3, 21);
}
```

- 実験用 1フレームごとの実時間
  - window.performance.now() は実験用のため例外的に使っているが、実際のゲームではticksを使うべし。でないとリプレイが破綻するはず。
```JavaScript
let lastUpdateTimeMsec = 0;
function update() {
  let now = window.performance.now();
  let deltaMsecInt = floor(now - lastUpdateTimeMsec);
  let xy = clamp((deltaMsecInt - 10) * 6, 10, 90);
  text(deltaMsecInt.toString(), xy, xy);
  lastUpdateTimeMsec = now;
}
```

# 関連情報

- 公式 crisp-game-lib
    - blog

        [残りゲーム制作体力10%な人のためのずぼらゲームライブラリcrisp-game-lib](https://aba.hatenablog.com/entry/2021/04/02/204732)
    - GitHub
        - [abagames / crisp-game-lib](https://github.com/abagames/crisp-game-lib)

- 手順やチュートリアル

    - [crisp-game-lib でゲームをつくるための手順](https://qiita.com/cat2151/items/851aa4923bebd125fcd7)

    - [Juno Nguyen氏による入門チュートリアル](https://github.com/JunoNgx/crisp-game-lib-tutorial)

