ArrowJS CMS
==================

Default account backend
```
    username: admin@example.com
    password: 123456
```

## API List:

- `/`: Trang giao diện trực quan để test post file binary
- `/api/login`: 
    - Method: `POST`
    - Consumes: application/x-www-form-urlencoded
    - Parameters:
        - `username`: email người dùng
        - `password`: mật khẩu người dùng
    - Response:
        - 403: Tài khoản không hợp lệ
        - 500: Lỗi Server
        - 200: Trả về Object gồm accessToken, authScheme và refreshToken:
            - authScheme: là phần prefix trong giá trị của header `authorization`
            - accessToken có thời hạn 30 phút
            - refreshToken có thời hạn 1 ngày
- `/api/refresh-token`:
    - Method: `POST`
    - Yêu cầu phải có jwt (kể cả accessToken đã hết hạn)
    - Consumes: application/x-www-form-urlencoded
    - Parameters:
        - `refreshToken`: refreshToken
    - Response:
        - 403: Token không hợp lệ hoặc đã hết hạn
        - 400: Bad Request
        - 500: Lỗi Server
        - 200: Trả về Object gồm accessToken, authScheme và refreshToken:
            - authScheme: là phần prefix trong giá trị của header `authorization`
            - accessToken có thời hạn 30 phút
            - refreshToken có thời hạn 1 ngày
- `/api/image-list`:
    - Method: `GET`
    - Yêu cầu phải có jwt
    - Produces: application/json
    - Response:
        - 403: Authenticate thất bại
        - 500: Lỗi Server
        - 200: Danh sách các ảnh
- `/api/create-image`:
    - Method: `POST`
    - Yêu cầu phải có jwt
    - Consumes: multipart/form-data
    - Parameters:
        - `name`: tên ảnh (text)
        - `photofile`: ảnh (binary)
    - Response:
        - 403: Authenticate thất bại
        - 500: Lỗi Server
        - 200: Thông tin của ảnh, bao gồm `name` và `photofile`. Xem ảnh tại đường dẫn `<photofile>`

## Requirements

To run this CMS you need at least:

- Nodejs 4.0.0 or higher
- Redis Server

## Installation 
```

Go to project folder and install npm packages

```
    sudo npm install
```
## Configuration

We tested with PostgreSQL and MySQL.
By default, Arrow CMS use PostgreSQL and Redis. If you don't have PostgreSQL modify the config file :


```
//Database config
//config/database.js
 db: {
        host: 'localhost',    // database host
        port: '5432',         // database port
        database: 'arrowjs',  // database name
        username: 'postgres', // database usename
        password: '',         // database password
        dialect: 'postgres',  // database type 
        logging: false
    },
    
```

## Run CMS

Start application:

```
    node server.js
```

or

```
    npm start
```

Now application start on port 8000 (default port, you can change it in file config/config.js or configure in server.js).

Admin account for backend (with URL /admin/login):

```
    username: admin
    password: 123456
```
You must change it after login for secure account.

## License

The MIT License (MIT)

Copyright (c) 2015 ArrowJS CMS

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.