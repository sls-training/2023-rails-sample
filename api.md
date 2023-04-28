# User API

ユーザを閲覧、削除、追加するための API。<br>

Header に BearerToken を必要とする。<br>
トークンの生成は Admin ユーザのみできることとし、/api/token を用いて生成を行う。<br>

次の場合にはそれぞれのエラーコードを返すこととする<br>
トークンがなくて失敗した場合には、403<br>
トークンが期限切れの場合には、401<br>
トークンが有効でないの場合には、401<br>

| endpoint          | 説明                         |
| ----------------- | ---------------------------- |
| GET /api/users    | 全てのユーザの情報を返す     |
| GET /api/user/:id | ユーザ ID のユーザ情報を返す |
| POST /api/user    | ユーザの作成                 |
| DELETE /api/user  | ユーザの削除                 |
| POST /api/token   | トークン生成                 |

## Header

```json
{
  "Authorization": "Bearer <YOUR-TOKEN>"
}
```

## GET /api/users

ユーザの一覧を返す API。

### リソース URL

http://localhost:3000/api/users

### Parameters

| 名称     | 型                     | 必須か   | 　説明       | デフォルト値 | 例      |
| -------- | ---------------------- | -------- | ------------ | ------------ | ------- |
| limit    | Integer                | optional | ユーザ取得数 | 無限         | 5       |
| register | 'newer' &#124; 'older' | optional | ユーザ登録順 | 'newer'      | 'older' |
| order    | 'desc' &#124; 'asc'    | optional | 並び順       | 'asc'        | 'desc'  |

### request

```bash
curl \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/user?limit=10&register=older&order=desc
```

### Response

200 OK

| プロパティ名 | 型      | 説明                   |
| ------------ | ------- | ---------------------- |
| id           | Integer | ユーザ ID              |
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

## GET /api/user

指定 ID のユーザのを返す API。

### リソース URL

http://localhost:3000/api/user/:id

### Parameters

| 名称 | 型      | 必須か   | 　説明    |
| ---- | ------- | -------- | --------- |
| id   | Integer | required | ユーザ ID |

### request

```bash
curl \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/user/123
```

### Response

200 OK

| プロパティ名 | 型      | 説明                   |
| ------------ | ------- | ---------------------- |
| id           | Integer | ユーザ ID              |
| name         | String  | ユーザ名               |
| email        | String  | メール                 |
| created_at   | Date    | 作成日                 |
| updated_at   | Date    | 更新日                 |
| admin        | Boolean | 管理者かどうか         |
| activated    | Boolean | メール認証済みかどうか |
| activated_at | Date    | メール認証した日       |

```json
{
  "id": 1,
  "name": "Example User",
  "email": "example@railstutorial.org",
  "created_at": "2023-04-20T07:52:47.897Z",
  "updated_at": "2023-04-25T06:37:02.675Z",
  "admin": true,
  "activated": true,
  "activated_at": "2023-04-20T07:52:47.665Z"
}
```

## POST /api/user

ユーザを作成する API。

### リソース URL

http://localhost:3000/api/user

### Parameters

| 名称  | 必須か   | 　説明   | 例                 |
| ----- | -------- | -------- | ------------------ |
| name  | required | ユーザ名 | "uouo chan"        |
| email | required | メール   | "test@example.com" |

## Request

```bash
curl -X POST\
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer <YOUR-TOKEN>"\
 -d '{"name": "testuser", "email":"hoge@example.com"}'
  http://localhost:3000/api/user
```

### Response

201 Created

````json
{
  "id": 1,
  "name": "Example User",
  "email": "example@railstutorial.org",
  "created_at": "2023-04-20T07:52:47.897Z",
  "updated_at": "2023-04-25T06:37:02.675Z",
  "admin": true,
  "activated": true,
  "activated_at": "2023-04-20T07:52:47.665Z"
}
```

## DELETE /api/user

ユーザの削除用 API

### リソース URL

http://localhost:3000/api/user

### Parameters

| 名称 | 必須か   | 　説明    | 例    |
| ---- | -------- | --------- | ----- |
| id   | required | ユーザ ID | 11111 |

### request

```bash
curl -X DELETE \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/user
````

### Response

200 OK

## POST /api/token

トークン発行用の API。<br>
ベアラートークンを生成する<br>
パスワードが間違っているなど情報が違う時には 401 Unauthorized を返す<br>
Admin ユーザ以外で失敗した時には 403 Forbidden を返す<br>

<!-- Todo: トークンを db に記録して検証できるようにする、有効期限切れなっていたら再生成する。
トークンの有効期限は 1 時間 -->

### リソース URL

http://localhost:3000/api/token

### Parameters

| 名称     | 必須か   | 　説明             | 例                 |
| -------- | -------- | ------------------ | ------------------ |
| email    | required | ユーザのメール     | "uouo@example.com" |
| password | required | ユーザのパスワード | "foobar"           |

### request

```bash
curl -X POST\
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer <YOUR-TOKEN>"\
 -d '{"email": "hoge@example.com", "password":"hogehoge"}'
  http://localhost:3000/api/token
```

### Response

| プロパティ名 | 型     | 説明             |
| ------------ | ------ | ---------------- |
| token_type   | Date   | タイプ           |
| access_token | String | アクセストークン |

- success

  200 OK

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
