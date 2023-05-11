# POST /api/users

ユーザを作成する API。

## リソース URL

http://localhost:3000/api/users

## Parameters

| 名称     | 型      | 必須か   | 　説明                             | 例                 |
| -------- | ------- | -------- | ---------------------------------- | ------------------ |
| name     | String  | required | ユーザ名                           | "uouo chan"        |
| email    | String  | required | メール                             | "test@example.com" |
| password | String  | required | パスワード                         | "hogehoge"         |
| admin    | Boolean |          | 管理者かどうか(デフォルトで false) | true               |

## Request

```bash
curl -X POST\
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer <YOUR-TOKEN>"\
 -d '{"name":"testuser", "email":"hoge@example.com", "password":"hogehoge"}'
  http://localhost:3000/api/users
```

## Response

### 201 Created

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
  "activated": false,
  "activated_at": null,
  "created_at": "2023-04-20T07:52:47.897Z",
  "updated_at": "2023-04-25T06:37:02.675Z"
}
```

### 400 Bad Request

- パラメータの形式が間違っていた場合

  ```json
  {
    "message": "Bad Request. Bad email address or name"
  }
  ```

- パラメータが足りない場合

  ```json
  {
    "message": "Bad Request. Please check if the parameters are wrong"
  }
  ```

- ユーザが既に存在している場合

  ```json
  {
    "message": "Bad Request. This user already exists"
  }
  ```

### 401 Unauthorized

- アクセストークンが無効な場合

  ```json
  {
    "message": "Unauthorized. Invalid token"
  }
  ```

- アクセストークンがない場合

  ```json
  {
    "message": "Unauthorized. Missing authentication token"
  }
  ```
