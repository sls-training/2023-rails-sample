# GET /api/users

ユーザ一覧を返す API。
ユーザは ID の昇順で取得される。

## リソース URL

http://localhost:3000/api/users

## Header

```yml
Authorization: Bearer <YOUR-TOKEN>
```

## Parameters

| 名称   | 型      | 必須か | 　説明                                 | デフォルト値 |
| ------ | ------- | ------ | -------------------------------------- | ------------ |
| limit  | Integer |        | 取得するデータの数の上限(最大値: 1000) | 50           |
| offset | Integer |        | どの位置からデータを取得するか         | 0            |

## Request

```bash
curl \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  "http://localhost:3000/api/users?limit=100&offset=50"
```

## Responses

### 200 OK

successful operation<br>
Content-Type: `application/json`

| プロパティ名 | 型                             | 説明                   |
| ------------ | ------------------------------ | ---------------------- |
| id           | Integer                        | ユーザ ID              |
| name         | String                         | ユーザ名               |
| email        | String                         | メール                 |
| admin        | Boolean                        | 管理者かどうか         |
| activated    | Boolean                        | メール認証済みかどうか |
| activated_at | DateTime(ISO 8601) &#124; null | メール認証した日       |
| created_at   | DateTime(ISO 8601)             | 作成日                 |
| updated_at   | DateTime(ISO 8601)             | 更新日                 |

```json
[
  {
    "id": 1,
    "name": "Example User",
    "email": "example@railstutorial.org",
    "admin": true,
    "activated": true,
    "activated_at": "2023-05-02T01:02:04Z",
    "created_at": "2023-05-01T01:01:04Z",
    "updated_at": "2023-05-03T01:05:04Z"
  },
  {
    "id": 2,
    "name": "Example User2",
    "email": "example2@railstutorial.org",
    "admin": false,
    "activated": true,
    "activated_at": "2023-05-02T01:02:04Z",
    "created_at": "2023-05-01T01:01:04Z",
    "updated_at": "2023-05-03T01:05:04Z"
  },
  ...
]
```

### 400

アクセストークンがない場合

```json
{
  "errors": [
    {
      "name": "access_token",
      "message": "Authentication token is missing"
    }
  ]
}
```

### 401

- アクセストークンが無効な場合

```json
{
  "errors": [
    {
      "name": "access_token",
      "message": "Invalid token"
    }
  ]
}
```
