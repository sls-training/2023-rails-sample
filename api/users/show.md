# GET /api/users/:id

指定 ID のユーザを返す API。

## リソース URL

http://localhost:3000/api/users/:id

## Header

```yml
'Authorization': 'Bearer <YOUR-TOKEN>'
```

## Parameters

| 名称 | 型      | 必須か   | 　説明    |
| ---- | ------- | -------- | --------- |
| id   | Integer | required | ユーザ ID |

## Request

```bash
curl \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/users/123
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
{
  "id": 1,
  "name": "Example User",
  "email": "example@railstutorial.org",
  "admin": true,
  "activated": true,
  "activated_at": "2023-05-02T01:02:04Z",
  "created_at": "2023-05-01T01:01:04Z",
  "updated_at": "2023-05-03T01:05:04Z"
}
```

### 400

アクセストークンがない場合

```json
{
  "message": "Authentication token is missing"
}
```

### 401

- アクセストークンが無効な場合

```json
{
  "message": "Invalid token"
}
```

### 404

存在しない ID を指定した場合

```json
{
  "message": "User does not exist"
}
```
