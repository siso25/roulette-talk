# roulette-talk
![top-page-logo](https://github.com/siso25/roulette-talk/assets/47073105/9ab1ffaf-db14-4be6-a7e3-b3f39674c83a)

## 概要
ルーレットトークは、オンライン飲み会で特定の人だけが話してしまう問題を解決する、オンライン飲み会主催者向けのトークテーマ提供サービスです。
トークテーマと話す人のルーレットを作成でき、主催者は予めトークテーマを設定したルーレットを作成できる機能が備わっていることが特徴です。

## URL
https://roulette-talk.com/

## 使い方
### 1. トップページで「ルーレットを作る」をクリックする
![image](https://github.com/siso25/roulette-talk/assets/47073105/106981ac-3ed9-4212-8f27-eb84f147246a)

### 2. トークテーマと話す人を設定する
![image](https://github.com/siso25/roulette-talk/assets/47073105/8e1368d2-5699-4eb1-a66d-9b0349a4568e)

### 3.「スタート」ボタンをクリックする
![image](https://github.com/siso25/roulette-talk/assets/47073105/9be9cb44-d4b6-4bec-8801-0693d538f92e)

## 動作環境
- Ruby 3.2.2
- Ruby on Rails 7.0.7.2
- Hotwire
- Node.js 20.10.0
- Yarn 1.22.21

## インストールと起動
```
$ git clone https://github.com/siso25/roulette-talk.git
$ cd roulette-talk
$ bin/setup
$ bin/dev
```

## テスト
```
$ be rspec
```

## Lint
```
$ bin/lint
```
実行されるlint
- Ruby
  - rubocop
  - slim-lint
- javascript
  - eslint
  - prettier
