# GET /api/users/:id

指定 ID のユーザのを返す API。

## リソース URL

http://localhost:3000/api/users/:id

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

### Scheme

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

<table>
<tr>
    <td> Status </td> 
    <td> Response </td>
</tr>
<tr>
<td> 200 </td>
<td>
successful operation

Media type: `application/json`

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

</td>
</tr>

<tr>
<td> 401 </td>
<td>

invalid token / user not activated

</td>
</tr>

<tr>
<td> 403 </td>
<td>

Missing authentication token

</td>
</tr>

</table>
