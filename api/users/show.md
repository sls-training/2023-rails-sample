# GET /api/users/:id

指定 ID のユーザを返す API。

日本標準時の現在時刻(JST/UTC+0900)。

## リソース URL

http://localhost:3000/api/users/:id

トークンが無効の場合は 401<br>
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

| プロパティ名 | 型                   | 説明                   |
| ------------ | -------------------- | ---------------------- |
| id           | Integer              | ユーザ ID              |
| name         | String               | ユーザ名               |
| email        | String               | メール                 |
| admin        | Boolean              | 管理者かどうか         |
| activated    | Boolean              | メール認証済みかどうか |
| activated_at | DateTime &#124; null | メール認証した日       |
| created_at   | DateTime             | 作成日                 |
| updated_at   | DateTime             | 更新日                 |

```json
{
  "id": 1,
  "name": "Example User",
  "email": "example@railstutorial.org",
  "admin": true,
  "activated": true,
  "activated_at": "Sat, 22 May 2021 14:55:10.214590000 JST +09:00",
  "created_at": "Sat, 22 May 2021 14:35:10.214590000 JST +09:00",
  "updated_at": "Fri, 2 July 2021 2:15:10.214590000 JST +09:00"
}
```

### 401

invalid token

### 403

Missing authentication token
