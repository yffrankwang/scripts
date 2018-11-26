■使用方法

    ■SQL*Plus Worksheetを使用する場合
        SQLファイルをSQL*Plusを起動するコンピュータの任意の場所にコピーします。
        Oracle Enterprise Managnerで目的のデータベースに接続します。
        SQL*Plus Worksheetを起動し、「ワークシート」「ローカルスクリプトの実行」を選択し、実行するファイルを選択します。

    ■SQL*Plusを使用する場合
        SQL*Plusを使用する場合は、SQL*Plusを起動し、目的のデータベースに接続します。
        @に続いて、ファイルのフルパスを指定します。

        　例)C:\Oracle\scripts　にselect_tab.sqlをおいた場合
        　　  SQL>@C:\Oracle\scripts\select_tab.sql

        SQL*Plusでは、画面バッファを多めに取ってください。
        「オプション」「環境」でバッファ幅を100以上、バッファ長を500以上にします。

    ■ご注意１
        select_rolesysprivs2.sql
        select_usertabprivs2.sql
        の二つのスクリプトは、SQL*Plusでのみ使用できます。
        SQL*Plus Worksheetでは対話式の実行ができませんので、使用できません。

    ■ご注意２
        Windows版SQL*Plusをお使いの方へ：
        Oracle SQL*Plus 9.0.1（GUI版)をお使いの場合、SQL*Plusの環境設定コマンドset pause onが正しく使用できません。
        そのため、スクリプト中はコメントにしています。
        set pause onは、検索結果が1ページに収まらない場合に、1画面づつ一時停止する機能です。
        SQL*Plus Worksheetをご使用になれば、検索結果がバッファリングされてますので、スクロールで戻って確認することが
        できるので、SQL*Plus Worksheetの使用をお勧めします。
        なお、MS-DOSからのsqlplusは画面幅が小さいため表示が正しく行われませんのでお勧めしません。
        Oracle8、8iのSQL*Plus(GUI版)の場合は、set pause onが使用できますので、以下のところを修正して利用することがで
        きます。(Oracle9iでSQL*Plusの修正版あるいはパッチが公開された場合は、set pause onが動くかもしれません)

            修正前：
            rem set pause on
            rem set pause 'Please enter the key'

            修正後：
            set pause on
            set pause 'Please enter the key'

    ■Linux版をお使いの方へ
        Linuxの場合、シェルからsqlplusを起動して使用してください。
        こちらはset pause onが利用できます。


    ■ファイル一覧

    select_tab.sql
      ○テーブル一覧表示　ログインしているユーザが保有するテーブル、シノニム、ビュー等の一覧を表示します。
        表示したいスキーマで接続してください。

    select_usertables.sql
      ○テーブル一覧詳細表示　ログインしているユーザが保有するテーブルの詳細情報を表示します。
        なお、ANALYZEを行っていないとデータの一部が表示されません。
        ANALYZE TABLE テーブル名 COMPUTE STATISTICS;
        表示したいスキーマで接続してください。

    select_userindcolumns.sql
      ○インデックス一覧表示　ログインしているユーザが保有するインデックス一覧を表示します。
        表示したいスキーマで接続してください。

    select_userindexes.sql
      ○インデックス一覧詳細表示　ログインしているユーザが保有するインデックスの詳細情報を表示します。
        表示したいスキーマで接続してください。

    select_userviews.sql
      ○ビュー一覧詳細表示　ログインしているユーザが保有するビューの詳細情報を表示します。
        表示したいスキーマで接続してください。

    select_dbausers.sql
      ○全ユーザ一覧表示　現在ログインしているインスタンスの全ユーザを表示します。
        SYS AS SYSDBAで接続してください。

    select_userroleprivs.sql
      ○ログインユーザ・ロール権限一覧　現在ログインしているユーザに付与されたロール権限一覧を表示します。
        表示したいスキーマで接続してください。

    select_userroleprivs2.sql
      ○ログインユーザ・システム権限一覧　ログインしているユーザに付与されたシステム権限一覧を表示します。
        表示したいスキーマで接続してください。

    select_rolesysprivs.sql
      ○ロール・システム権限表示　ロールにセットされたシステム権限の一覧を表示します。
        SYS AS SYSDBAで接続してください。

    select_rolesysprivs2.sql
      ○指定ロール・システム権限表示　指定したロールにセットされたシステム権限の一覧を表示します。
      "どのロールについて表示しますか？> "　と表示されたらロール名を入力します。
        SYS AS SYSDBAで接続してください。
        SQL*Plus Worksheetでは使用できません。

    select_usertabprivs.sql
      ○ログインユーザ・オブジェクト権限一覧　現在ログインしているユーザに付与されたオブジェクト権限一覧を表示します。
        表示したいスキーマで接続してください。

    select_usertabprivs2.sql
      ○指定ユーザ・オブジェクト権限表示　指定したユーザに付与されたオブジェクト権限の一覧を表示します。
      "どのユーザについて表示しますか？> "　と表示されたらユーザ名を入力します。
        SYS AS SYSDBAで接続してください。
        SQL*Plus Worksheetでは使用できません。

    select_vparameter2.sql
      ○初期化パラメータ一覧表示　ログインしているデータベースの初期化パラメータの一覧を表示します。
        SYS AS SYSDBAで接続してください。

    select_dbadatafiles.sql
      ○表領域状態表示　表領域の使用状況、ファイル名の一覧を表示します。
        SYS AS SYSDBAで接続してください。

    select_backupfiles.sql
      ○バックアップ用ファイル表示　オフラインバックアップでバックアップするファイル一覧を表示します。
        SYS AS SYSDBAで接続してください。
