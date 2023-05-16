## POST /api/token

トークン発行用の API。<br>
ベアラートークンを生成する<br>
パスワードが間違っているなど情報が違う時には 401 Unauthorized を返す<br>
Admin ユーザ以外で失敗した時には 403 Forbidden を返す<br>

### リソース URL

http://localhost:3000/api/token

### Parameters

| 名称     | 必須か   | 　説明             | 例                 |
| -------- | -------- | ------------------ | ------------------ |
| email    | required | ユーザのメール     | "uouo@example.com" |
| password | required | ユーザのパスワード | "foobar"           |

### requests

```bash
curl -X POST\
 -H "Content-Type: application/json" \
 -d '{"email": "hoge@example.com", "password":"hogehoge"}'
  http://localhost:3000/api/token
```

### Response

| プロパティ名 | 型     | 説明             |
| ------------ | ------ | ---------------- |
| access_token | String | アクセストークン |

200 OK

```json
{
  "access_token": "AAAAAAAAAAAAAAAAAAAAAMLheAAAAAAA0%2BuSeid%2BULvsea4JtiGRiSDSJSI%3DEUifiRBkKG5E2XzMDjRfl76ZC9Ub0wnz4XsNiRVBChTYbJcE3F"
}
```

401 Unauthorized

```json
{
  "message": "Make sure you have the parameters."
}
```

403 Forbidden

```json
{
  "message": "You are not admin user"
}
```
