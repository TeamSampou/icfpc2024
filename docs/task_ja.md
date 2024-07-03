# タスク

多くの人が覚えているように、2006 年に私たちは、束縛変光教団と呼ばれる古い社会の文書を発見しました。ICFP コミュニティの貴重な支援により、この教団のコンピューティング デバイス (ユニバーサル マシン) が復活し、多くの興味深い情報が回収されました。ペゴフカ天文台による最近の観測で、驚くべき事実が判明しました。束縛変光教団は依然として存在し、文明を宇宙に移住させているのです。遠藤が再び地球から脱出した後、彼らの移住を助けたのではないかと考えられています。

数か月にわたる調査の結果、私たちは受信したメッセージのほとんどを解読し、通信チャネルを確立することができました。束縛変光教団の人々は現在、星間通信機能プログラム (ICFP) を使用して通信しています。ICFP 表現に関する私たちの調査結果は、このページでご覧いただけます。

## 挑戦

通信言語の解読には成功しましたが、残念ながら私たちだけでは解決できない課題に直面しました。もう一度、皆さんの協力をお願いします。通信チャネルは、学生が宇宙での生活に必要なさまざまなスキルを学ぶためにいくつかのコースを受講できる MOOC である School of the Bound Variable と通信します。各コースには一連のテストがあり、何らかの基準に従って採点されます。

重要な注意: 基本的な通信では文字列のみが使用されるようです。したがって、より高度な ICFP 式は必要な場合にのみ実装し、文字列から始めることをお勧めします。

## 通信チャンネル

通信を試すために、カルトとの通信チャネルを開いています。ICFP を本文に含めて HTTP POST リクエストを https://boundvariable.space/communicate に送信すると、リクエストが銀河に送信され、応答が返されます。識別のために、チーム ページにある Authorization ヘッダーを送信する必要があります。

お気に入りのプログラミング言語から直接 POST リクエストを行うことを強くお勧めしますが、Web ベースの通信も提供しています。そのページには、通信履歴も表示されます。

さらに、S'%4}).$%8 を送信することは、束縛変数カルトの学校と通信するための優れたエントリポイントであることがわかりました。

## 制限

宇宙との通信はエネルギーを消費するプロセスであるため、環境および金銭上の理由から、メッセージに制限を設けています。リクエストの POST 本体は 1 MB (1048576 バイト) を超えてはならず、1 分間に送信できるメッセージは最大 20 件です。

## 得点

各コースのテストは、コースに入るときに説明される基準に従って採点されます。各テストの最高スコアが保存されます。スコアボード ページには、各コースのすべてのチームのランクの概要とグローバル ランクが表示されています。コースの個々のテストのすべてのスコアに基づいてコースのランクを検索したり、コースのランクに基づいてグローバル ランクを検索したりするには、いわゆる Borda カウントを使用します。

技術的には、ランクリストは選挙であり、チームが候補者でテストが投票者です。個々のテストで良い成績を収めれば収めるほど、このテストでの順位は高くなります。より直感的に説明すると、各テストで獲得したポイントの量は、そのテストであなたより明らかに低いスコアを獲得したチームの数であり、そのコースのランキングリストはそれらのポイントの合計に基づいています。この方法は、最初にコースごとのランキングリストを計算するために使用され、次に個々のコースのランクを使用してグローバルランクを見つけます。

これは抽象的に聞こえるかもしれませんが、これだけ知っておく必要があると思います。また、この評価システムの重要な特性は、絶対スコアは重要ではなく、順序だけが重要であることです。また、同点も自然に処理され (一部のテストは単に正解/不正解で、それを解いた全員が 1 位で同点になります)、異なる絶対スコア範囲のテストのバランスが自動的に取られます。そしてもちろん、すべてのテストで最高のスコアを獲得するように努めてください。

## 最終コードのサブミット

賞品の対象となるには、コンテスト終了間際にチームページからコードを送信してください。コードの送信は、コンテスト終了の 3 時間後に終了します。ライトニング ラウンド用に別途提出する必要はありませんが、最初の 24 時間の部分を示す README ファイルを添付してください。

## メタノート

紹介では ICFP プログラミング コンテストのさまざまなエディションについて言及していますが、今年設定されたタスクはまったく新しいものであり、以前のチャレンジの知識は不要であることを明確にしておきます。ただし、それらのコンテストを楽しんだため、それらについて言及したので、今年のコンテストが終了したら、まだ試していない場合は、ぜひ試すことをお勧めします。

すべてのタイムゾーンでコンテストを公平にするために、コンテスト中にタスクに変更を加える予定はありません。ただし、ライトニング ラウンドの最後に追加情報を公開する可能性があります。

最後に、参加者へのお願いです。コンテストを楽しんでください。ただし、他の人も楽しめるようにしてください。サーバーはかなり堅牢なはずですが、サーバーを破壊しようとしないでください。ただし、ICFPC の主催者は、自由時間にこのコンテストを主催するボランティアであることを忘れないでください。これまでのところ、私たちは準備に非常に楽しんでいます。そのことをできるだけ皆さんと共有したいと思っています。

### ICFP 言語
星間通信機能プログラム (ICFP) は、スペースで区切られたトークンのリストで構成されています。トークンは、ASCII コード 33 ('!') からコード 126 ('~') までの 1 つ以上の印刷可能な ASCII 文字で構成されます。言い換えると、94 の文字が可能で、トークンはそのような文字の空でないシーケンスです。

トークンの最初の文字はインジケータと呼ばれ、トークンのタイプを決定します。トークンの残りの部分 (空の場合もあります) は本体と呼ばれます。さまざまなトークン タイプについては、次のサブセクションで説明します。

## 論理値

`indicator = T` かつ、本体が空の場合は、true、`indicator = F` かつ、本体が空の場合は false を表す

## 整数
`indicator = I` 本体は非空でなければならない

本文は 94 進数として解釈されます。つまり、数字は 94 個の印刷可能な ASCII 文字で、感嘆符は 0、二重引用符は 1 などを表します。たとえば、I/6 は数値 1337 を表します。

## 文字列
`indicator = S`

Cult of the Bound 変数は、文字をエンコードするために ASCII に似たシステムを使用しているようですが、順序が少し異なります。具体的には、本文の ASCII コード 33 から 126 は、次の順序で変換することで、人間が読めるテキストに変換できます。

```
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"#$%&'()*+,-./:;<=>?@[\]^_`|~<space><newline>
```

ここで、<space> は 1 つのスペース文字、<newline> は 1 つの改行文字を表します。たとえば、SB%,,//Q/2,$_ は文字列 "Hello World!" を表します。

## 単項演算子

`indicator = U` は、ちょうど 1 文字の長さの本体を必要とし、その後に続くトークンから解析できる ICFP が続く必要があります。

| 字 | 意味 | 例 |
|:-----|:-----|:---|
| `-` | 整数の符号反転 | `U- I$` → `-3` |
| `!` | 論理値の否定 | `U! T` → `false`
| `#` | 文字列を整数に変換: 文字列をbase-94数と解釈 | `U# S4%34` → `15818151`|
| `$` | 整数も文字列に変換: 上の逆演算 | `U$ I4%34` → `test`|


この表の → 記号は「評価結果」と読み替えてください。Evaluation節を参照してください。

## 二項演算子

`indicator = B` は、ちょうど 1 文字の長さの本体が必要で、その後に 2 つの ICFP (x と y と呼ぶことにします) が続く必要があります。


| 字 | 意味 | 例 |
|:---|:---|:---|
|`+`| 整数の足し算 | `B+ I# I$` → `5` |
|`-`| 整数の引き算 | `B- I$ I#` → `1` |
|`*`| 整数の掛け算 | `B* I$ I#` → `6` |
|`/`| 整数の割り算 (0に向って丸める) Haskellだと`quot` | `B/ U- I( I#` → `-3` |
|`%`| 整数の剰余算 Haskellだと `rem` | `B% U- I( I#` → `-1` |
|`<`| 整数の比較 | `B< I$ I#` → `false`|
|`>`| 整数の比較 | `B> I$ I#` → `true` |
|`=`| 同値判定、整数、論理値、文字列で使える | `B= I$ I#` → `false`
|`\|`| 論理和 |`B\| T F` → `true`|
|`&`| 論理積 | `B& T F`false |
|`.`| 文字列連結 | `B. S4% S34` →  `"test"` |
|`T`| 文字列`y`の先頭`x`文字取ったもの Haskellの`take` |`BT I$ S4%34` → `"tes"`|
|`D`| 文字列`y`の先頭`x`文字落したもの Haskellの`drop` |`BD I$ S4%34` → `"t"` |
|`$`| 項`x`を`y`に適用(λ抽象の節参照) ||

## IF
`indicator = ?` は、空の本体を持ち、その後に 3 つの ICFP が続きます。最初の ICFP はブール値として評価され、それが true の場合は 2 番目の ICFP が評価されて結果が返され、そうでない場合は 3 番目の ICFP が評価されます。例:
```
? B> I# I$ S9%3 S./
```
評価結果は`no`になる

## λ抽象
`indicator = L` はλ抽象化であり、本体は変数番号である整数と同じように 94 進数として解釈される必要があります。`indicator = v` は変数であり、この場合も本体は 94 進数の変数番号です。

indicator = L はラムダ抽象化であり、その本体は整数と同じように 94 進数として解釈され、変数番号となります。indicator = v は変数であり、やはり本体は 94 進数です。

λ抽象が二項演算子`$` の最初の引数として現れる場合、適用の 2 番目の引数がその変数に割り当てられます。たとえば、ICFP
```
B$ B$ L# L$ v# B. SB%,,/ S}Q/2,$_ IK
```
これは、Haskellスタイルでは以下のプログラムを表わす。
```
((\v2 -> \v3 -> v2) ("Hello" . " World!")) 42
```
これの評価結果は`"Hell World!"`である。

## 評価

最も普及している ICFP メッセージング ソフトウェアである Macroware Insight は、名前による呼び出し(call-by-name)戦略を使用して ICFP メッセージを評価します。つまり、バイナリ アプリケーション演算子は非厳密であり、2 番目の引数はバインディング変数の代わりに置換されます (キャプチャ回避置換を使用)。上記の例の v3 のように、λ抽象の本体で引数が使用されていない場合は、評価されません。変数が複数回使用される場合、式は複数回評価されます。

たとえば、以下のような評価ステップになります。

```
B$ L# B$ L" B+ v" v" B* I$ I# v8
B$ L" B+ v" v" B* I$ I#
B+ B* I$ I# B* I$ I#
B+ I' B* I$ I#
B+ I' I'
I-
```

## 制限

地球との通信は複雑なため、Cultは Macroware Insight ソフトウェアにいくつかの制限を設けているようです。具体的には、β簡約回数が 10_000_000 を超えるとメッセージ処理が中止されます。組み込み演算子は厳密であり (もちろん B$ を除く)、β簡約の制限にはカウントされません。したがって、参加者のメッセージはこれらの制限内に収まる必要があります。

たとえば、評価結果が 16 になる、次の項は、評価中に 109 回のβ簡約が行われる。

```
B$ B$ L" B$ L# B$ v" B$ v# v# L# B$ v" B$ v# v# L" L# ? B= v# I! I" B$ L$ B+ B$ v" v$ B$ v" v$ B- v# I" I%
```

研究者は、β簡約量の制限が参加者が遭遇する唯一の制限であると予想していますが、メモリ使用量と合計実行時間にもいくつかの (未知の) 制限があるようです。

## 未知の演算子
上記の言語構成は研究者が発見した全てであり、カルトが地球とのコミュニケーションにこれ以外の言語構成を使用することはないと推測されます。ただし、さらに言語構成が存在するかどうかは不明です。
