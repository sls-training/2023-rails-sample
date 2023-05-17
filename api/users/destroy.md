# DELETE /api/users/:id

ユーザの削除用 API

## リソース URL

http://localhost:3000/api/users/:id

## Parameters

| 名称 | 型      | 必須か   | 　説明    | 例    |
| ---- | ------- | -------- | --------- | ----- |
| id   | Integer | required | ユーザ ID | 11111 |

## request

```bash
curl -X DELETE \
  -H "Authorization: Bearer <YOUR-TOKEN>"\
  http://localhost:3000/api/users/123
```

## Response

### 204 No Content

Nothing

### 400 Bad Request

- アクセストークンがない場合

```json
{
  "errors": [
    {
      "name": "access_token",
      "message": "Bad Request. Missing authentication token"
    }
  ]
}
```

### 401 Unauthorized

- アクセストークンが無効な場合

```json
{
  "errors": [
    {
      "token": "access_token",
      "message": "Unauthorized. Invalid token"
    }
  ]
}
```

### 404 Not Found

- 存在しない ID を指定した場合

```json
{
  "errors": [
    {
      "name": "user_id",
      "message": "Not Found. User does not exist"
    }
  ]
}
```

### 422 Unprocessable Entity

- 自分の ID を指定した場合

```json
{
  "errors": [
    {
      "name": "user_id",
      "message": "You can't delete yourself"
    }
  ]
}
```
