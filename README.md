<img height="180" style="border-radius: 32px; display: block; margin: auto;" src="Zappingourmet.jpg" />

# ザッピングルメ！ (Zappingourmet-iOS)

近くのレストランをザッピングして、行きたい場所をその場で決められる！

## 動作対象OS

iOS 14.0 以上

## アプリケーション

### 機能一覧

- 店舗検索
  - ホットペッパー「グルメサーチAPI」で現在地周辺の飲食店を検索
  - 検索範囲を5段階に切り替え可能
  - マップ上で現在地・検索範囲を確認可能
  - ホットペッパー「ジャンルマスタAPI」が提供するジャンルで絞り込み可能
- 店舗情報取得
  - 検索した店舗名・営業時間などの基本情報を表示
  - 個室の有無などの詳細情報はタグクラウド風に表示
- 現在地から店舗への徒歩ルート表示
  - 店舗の住所も併せて表示
- 店舗のURLを開く
  - デバイス既定のブラウザで開く
  - URLはホットペッパーのページと思われるが、リファレンスに明記されていないため「ホットペッパーで開く」のような記述にはしていない

### 画面一覧

- 検索入力
  - 現在地(位置情報)、範囲、ジャンルを指定して店舗検索
- 店舗一覧
  - 検索条件に合った店舗をリスト表示
- 店舗詳細
  - 店舗一覧から選んだ店舗の詳細情報を表示

### 使用しているAPI、ライブラリ

- [ホットペッパーグルメサーチAPI](https://webservice.recruit.co.jp/doc/hotpepper/reference.html)
- [Moya](https://github.com/Moya/Moya)
