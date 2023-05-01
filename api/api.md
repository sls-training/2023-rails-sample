# Users API

ユーザを閲覧、削除、追加するための API。<br>

Header に BearerToken を必要とする。<br>
トークンの生成は Admin ユーザのみできることとし、/api/token を用いて生成を行う。<br>

次の場合にはそれぞれのエラーコードを返すこととする<br>
トークンがなくて失敗した場合には、403<br>
トークンが期限切れの場合には、401<br>
トークンが有効でないの場合には、401<br>

| endpoint           | 説明                         |
| ------------------ | ---------------------------- |
| GET /api/users     | 全てのユーザの情報を返す     |
| GET /api/users/:id | ユーザ ID のユーザ情報を返す |
| POST /api/users    | ユーザの作成                 |
| DELETE /api/users  | ユーザの削除                 |
| POST /api/token    | トークン生成                 |

## Header

```json
{
  "Authorization": "Bearer <YOUR-TOKEN>"
}
```

- failed

  401 Forbidden

  ```json
  {
    "message": "Invalid token. You have to recreate the token again"
  }
  ```

  403 Forbidden

  ```json
  {
    "message": "Access denied. You are not admin user"
  }
  ```
