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
  http://localhost:3000/api/users?limit=10&register=older&order=desc
```

### Response

200 OK

| プロパティ名 | 型       | 説明                   |
| ------------ | -------- | ---------------------- |
| id           | Integer  | ユーザ ID              |
| name         | String   | ユーザ名               |
| email        | String   | メール                 |
| created_at   | DateTime | 作成日                 |
| updated_at   | DateTime | 更新日                 |
| admin        | Boolean  | 管理者かどうか         |
| activated    | Boolean  | メール認証済みかどうか |
| activated_at | DateTime | メール認証した日       |

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

## GET /api/users

指定 ID のユーザのを返す API。

### リソース URL

http://localhost:3000/api/users/:id

### Parameters

| 名称 | 型      | 必須か   | 　説明    |
| ---- | ------- | -------- | --------- |
| id   | Integer | required | ユーザ ID |

### request

```bash
curl \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/users/123
```

### Response

200 OK

| プロパティ名 | 型       | 説明                   |
| ------------ | -------- | ---------------------- |
| id           | Integer  | ユーザ ID              |
| name         | String   | ユーザ名               |
| email        | String   | メール                 |
| created_at   | DateTime | 作成日                 |
| updated_at   | DateTime | 更新日                 |
| admin        | Boolean  | 管理者かどうか         |
| activated    | Boolean  | メール認証済みかどうか |
| activated_at | DateTime | メール認証した日       |

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

## POST /api/users

ユーザを作成する API。

### リソース URL

http://localhost:3000/api/users

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
  http://localhost:3000/api/users
```

### Response

201 Created

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

## DELETE /api/users/:id

ユーザの削除用 API

### リソース URL

http://localhost:3000/api/users/:id

### Parameters

| 名称 | 必須か   | 　説明    | 例    |
| ---- | -------- | --------- | ----- |
| id   | required | ユーザ ID | 11111 |

### request

```bash
curl -X DELETE \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/users/123
```

### Response

204 No Content
