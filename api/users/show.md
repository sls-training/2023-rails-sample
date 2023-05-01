# GET /api/users/:id

指定 ID のユーザを返す API。

## リソース URL

http://localhost:3000/api/users/:id

トークンが無効、ユーザがメール認証済みでない場合は 401<br>
トークンがない時は 403<br>

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

| プロパティ名 | 型       | 説明                   |
| ------------ | -------- | ---------------------- |
| id           | Integer  | ユーザ ID              |
| name         | String   | ユーザ名               |
| email        | String   | メール                 |
| admin        | Boolean  | 管理者かどうか         |
| activated    | Boolean  | メール認証済みかどうか |
| activated_at | DateTime | メール認証した日       |
| created_at   | DateTime | 作成日                 |
| updated_at   | DateTime | 更新日                 |

```json
{
  "id": 1,
  "name": "Example User",
  "email": "example@railstutorial.org",
  "admin": true,
  "activated": true,
  "activated_at": "2023-04-20T07:52:47.665Z",
  "created_at": "2023-04-20T07:52:47.897Z",
  "updated_at": "2023-04-25T06:37:02.675Z"
}
```

### 401

invalid token / user not activated

### 403

Missing authentication token
