# User API

ユーザを閲覧、削除、追加するための API。<br>

Header に BearerToken を必要とする。<br>
トークンの生成は Admin ユーザのみできることとし、/api/v1/token を用いて生成を行う。<br>

次の場合にはそれぞれのエラーコードを返すこととする<br>
トークンがなくて失敗した場合には、403(message: missing_access_token)<br>
トークンが期限切れ 401(message: expired_access_token)<br>
トークンが有効でない 401(message: invalid_access_token)<br>

| endopoint            | 説明                         |
| -------------------- | ---------------------------- |
| GET /api/v1/users    | 全てのユーザの情報を返す     |
| GET /api/v1/user/:id | ユーザ ID のユーザ情報を返す |
| POST /api/v1/user    | ユーザの作成                 |
| DELETE /api/v1/user  | ユーザの削除                 |
| POST /api/v1/login   | トークン生成                 |

## Header

```json
{
  "Authorization": "Bearer token_required"
}
```

## GET /api/v1/users

ユーザの一覧を返す API。

何かパラメータをつけてみたいので limit を追加してみている

### リソース URL

http://localhost:3000/api/v1/user

### Parameters

| 名称  | 必須か   | 　説明       | デフォルト値 | 例  |
| ----- | -------- | ------------ | ------------ | --- |
| limit | optional | ユーザ取得数 | 無限         | 5   |

### Response

| プロパティ名 | 型      | 説明                   |
| ------------ | ------- | ---------------------- |
| id           | Number  | ユーザ ID              |
| name         | String  | ユーザ名               |
| email        | String  | メール                 |
| created_at   | Date    | 作成日                 |
| updated_at   | Date    | 更新日                 |
| admin        | Boolean | 管理者かどうか         |
| activated    | Boolean | メール認証済みかどうか |
| activated_at | Date    | メール認証した日       |

```json
{
  "users": [
    {
      "id": 1,
      "name": "Example User",
      "email": "example@railstutorial.org",
      "created_at": "2023-04-20T07:52:47.897Z",
      "updated_at": "2023-04-25T06:37:02.675Z",
      "admin": true,
      "activated": true,
      "activated_at": "2023-04-20T07:52:47.665Z",
    },
    {
      "id": 3,
      "name": "Sen. Gloria Corwin",
      "email": "example-2@railstutorial.org",
      "created_at": "2023-04-20T07:52:48.935Z",
      "updated_at": "2023-04-20T07:52:48.935Z",
      "admin": false,
      "activated": true,
      "activated_at": "2023-04-20T07:52:48.713Z",
    },
   ...
  ]
}
```

## POST /api/v1/user

ユーザを作成する API。
使用するには admin ユーザで/api/v1/login からトークン情報を生成する必要がある。


### リソース URL

http://localhost:3000/api/v1/user

### Parameters

| 名称      | 必須か   | 　説明                       | 例                    |
| --------- | -------- | ---------------------------- | --------------------- |
| name      | required | ユーザ名                     | "uouo chan"           |
| email     | required | メール                       | "test@example.com"    |

### Response

200 OK

## DELETE /api/v1/user

ユーザの削除用 API

### リソース URL

http://localhost:3000/api/v1/user

### Parameters

| 名称      | 必須か   | 　説明                       | 例                    |
| --------- | -------- | ---------------------------- | --------------------- |
| id        | required | ユーザ ID                    | 11111                 |

### Response

200 OK

## POST /api/v1/token

トークン発行用の API。<br>
ベアラートークンを生成する<br>
パスワードが間違っているなど情報が違う時には 401 Unauthorized を返す<br>
Admin ユーザ以外で失敗した時には 403 Forbidden を返す<br>

<!-- Todo: トークンを db に記録して検証できるようにする、有効期限切れなっていたら再生成する。
トークンの有効期限は 1 時間 -->

### リソース URL

http://localhost:3000/api/v1/token

### Parameters

| 名称          | 必須か   | 　説明             | 例                 |
| ------------- | -------- | ------------------ | ------------------ |
| user_email    | required | ユーザのメール     | "uouo@example.com" |
| user_password | required | ユーザのパスワード | "foobar"           |

### Response

| プロパティ名 | 型     | 説明             |
| ------------ | ------ | ---------------- |
| token_type   | Date   | タイプ           |
| access_token | String | アクセストークン |

- success

```json
{
  "token_type": "bearer",
  "access_token": "AAAAAAAAAAAAAAAAAAAAAMLheAAAAAAA0%2BuSeid%2BULvsea4JtiGRiSDSJSI%3DEUifiRBkKG5E2XzMDjRfl76ZC9Ub0wnz4XsNiRVBChTYbJcE3F"
}
```

- failed

  403 Forbidden

```json
{
  "mssage": "Access denied. you are not admin user"
}
```
