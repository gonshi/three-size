# Readme

## 開発を始める時 
* npm install && bower install を実行してください
* grunt のwatchがキャパオーバーを起こしてエラーになる場合があるため、
  そのときは、 ulimit -n 1024 という風に、使用メモリ量を増やしてください。

## ファイル構成
 |- api_server (easymockのディレクトリです。ローカル用apiを立ち上げることができます。)
 |- bower_components (bowerでインストールしたライブラリ群が入っています)
 |- config (Jadeで使われるjsonファイルが入っています)
 |- grunt (gruntの実行ファイル群。load-grunt-configを導入しています。)
 |- node-modules (node.js のファイル群。基本的にいじることはない。)
 |- src (ソースファイル群。普段はここの中をいじります。)
    |- sass
    |- coffee 
    |- jade 

## grunt コマンド群

### grunt dev
* 開発用タスクです。
* livereloadが走ります

### grunt build
* production版のファイル群を作成します
* destinationは1階層下のディレクトリ(開発ディレクトリは/\_buildを想定しています)

## sassについて
- 各種設定: config.rb 
- src/sass/base/ reset, mixin, 変数などを管理します

## Jadeについて
- includeファイルはすべて /jade/include 以下にまとめて管理しています。
- mixinファイルはすべて /jade/mixin 以下にまとめて管理しています。

## coffeescriptについて
- browserifyによってモジュール管理をしています。
- ファイル構成はMVCをベースにしています。
