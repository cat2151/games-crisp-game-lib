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

- 描画
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

# 関連情報

- 公式 crisp-game-lib
    - blog

        [残りゲーム制作体力10%な人のためのずぼらゲームライブラリcrisp-game-lib](https://aba.hatenablog.com/entry/2021/04/02/204732)
    - GitHub
        - [abagames / crisp-game-lib](https://github.com/abagames/crisp-game-lib)

- 手順やチュートリアル

    - [crisp-game-lib でゲームをつくるための手順](https://qiita.com/cat2151/items/851aa4923bebd125fcd7)

    - [Juno Nguyen氏による入門チュートリアル](https://github.com/JunoNgx/crisp-game-lib-tutorial)

