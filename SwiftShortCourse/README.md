#Dự án iFarm
# Mô tả
Đây là dự án giả tưởng demo cho khóa học iOS Swift và Node.js tại Techmaster. Dự án này giúp nông dân quản lý từ xa các thông số nhiệt độ, độ ẩm, độ PH của đất, cảm biến gió, mưa qua các cảm biến. Cảm biến gửi dữ liệu lên Hub. Hub gửi dữ liệu lên server. Nông dân sẽ dùng di động để đọc dữ liệu từ server.

Một nhà nông có thể quản lý nhiều khoanh đất, ruộng, trang trại. Mỗi một đơn vị như vậy sẽ có một hub thu thấp số liệu từ các sensor

# Farmer Use Case:

- [Manage Sensors](#manage-sensors)
- [Manage Farms](#manage-farms)
- [Manage Alerts](#manage-alerts)
- [Monitor Farm](#monitor-farm)
- [My Account](#my-account)


# <a name="manage-sensors"></a>Manage sensors
Bao gồm các chức năng:
- Xem danh sách `Sensor` của từng `Farm`
- Xem/Chỉnh sửa thông tin cơ bản `Sensor`
- Tạo mới `Sensor` cho `Farm`/Xóa `Sensor` khỏi `Farm`
- Khai báo các ngưỡng quy định trạng thái cảnh báo cho `Sensor`

__Bảng Sensor:__

| Field       	| Required 	| Description                                                   	| Data Type 	|
|-------------	|:---------:|---------------------------------------------------------------	|-----------	|
| ID          	|     *    	| ID của `Sensor`                                                 	| String    	|
| farm       	|     *    	| ID của `Farm`                                               	    | Integer   	|
| description 	|          	| Mô tả ngắn                                                      	| String     	|
| longitude   	|          	| Kinh độ                                                       	| Float     	|
| latitude    	|          	| Vĩ độ                                                         	| Float     	|
| status      	|          	| Trạng thái:  0(_Disable_), 1(_Alarm_), 2(_Offline_), 3(_Online_)  | Integer   	|
| createdAt   	|          	| Thời điểm tạo `Sensor`                                            | Datetime  	|
| createdBy   	|          	| ID của người tạo `Sensor`                                         | Integer     	|
| modifiedAt  	|          	| Thời điểm cuối cập nhật `Sensor`                                  | Datetime  	|

__Bảng SensorRange:__

| Field       	| Required 	| Description          	| Data Type  	|
|-------------	|:--------:	|----------------------	|------------	|
| ID          	|     *    	| ID của `SensorRange` 	| Long      	|
| sensorId    	|     *    	| ID của `Sensor`      	| String     	|
| temperature 	|          	| Giới hạn nhiệt độ    	| Object (*) 	|
| moisture    	|          	| Giới hạn độ ẩm       	| Object (*) 	|
| pH          	|          	| Giới hạn độ pH       	| Object (*) 	|
| battery     	|          	| Giới hạn pin         	| Object (*) 	|

_(*) Chú thích:_
```
{
    from: float,
    to: float
}
```

# <a name="manage-farms"></a>Manage farms
Mỗi Farm tương ứng với 1 Hub, chịu trách nhiệm quản lý các Sensor được gán cho nó.
Trong phần `Manage Farms` sẽ bao gồm các chức năng:
- Tạo Farm mới
- Xem/Chỉnh sửa thông tin chi tiết của Farm
- Gán Sensor cho Farm/ Loại bỏ Sensor khỏi Farm
- Thiết lập Email, tin nhắn điện thoại thông báo:
    - Bổ sung thêm danh sách Email, số điện thoại (mặc định thông báo tới Email, số điện thoại mặc định của chủ sở hữ)
    - Các loại thông báo:
        - Thông báo __Alarm__ (khi Sensor chuyển sang trạng thái Alarm)
        - Thông báo __khác__ (khi Sensor chuyển sang các trạng thái còn lại: _Disable_, _Offline_, _Online_)
- Xóa Farm

__Bảng Farm:__

| Field   	    | Required 	| Description              	| Data Type       	|
|--------------	|:--------:	|--------------------------	|-----------------	|
| ID      	    |     *    	| ID của `Farm`        	    | Integer         	|
| title   	    |     *    	| Định danh cho `Farm`   	| String          	|
| description 	|          	| Mô tả ngắn                | String     	    |
| owner   	    |     *    	| ID chủ sở hữu            	| Integer         	|
| sensors 	    |          	| Danh sách ID các `Sensor` | Array (String) 	|

__Bảng AlertScript:__

| Field   	| Required 	| Description                       	| Data Type      	|
|---------	|:--------:	|-----------------------------------	|----------------	|
| ID      	|     *    	| ID của `AlertScript`                  | Integer        	|
| title   	|     *    	| Định danh cho `AlertScript`           | String         	|
| farm    	|     *    	| ID của `Farm                     	    | Integer        	|
| emails  	|     *    	| Danh sách Email                   	| Array (String) 	|
| phones  	|     *    	| Danh sách số điện thoại           	| Array (String) 	|
| content 	|     *    	| Nội dung (*)                      	| Object (JSON)  	|
| type    	|     *    	| Loại thông báo: 0(_Alarm_), 1(_Khác_) | Integer        	|

_(*) Chú thích:_
```
content: {
    email: string,
    phone: string
}
```

# <a name="manage-alerts"></a>Manage alerts
Thông báo sẽ được khởi tạo và gửi tự động khi phát hiện bất thường ở tín hiệu nhận từ `Sensor` (thông qua Hub).
Hệ thống sẽ dùng crontab để hẹn thời gian gửi lại thông báo nếu như lần trước đó chưa gửi thành công (tùy thuộc vào loại thông báo).
Người dùng cũng có thể khởi tạo và chỉnh sửa nội dung thông báo bằng tay. Phần `Manage alerts` bao gồm các chức năng:
- Tạo Thông báo
- Xem danh sách (lịch sử) thông báo
- Xem chi tiết/ Chỉnh sửa thông báo
- Gửi Thông báo

__Bảng Alert:__

| Field      	| Required 	| Description                          	| Data Type      	|
|------------	|:--------:	|--------------------------------------	|----------------	|
| ID         	|     *    	| ID của `Alert`                       	| Integer        	|
| farm       	|     *    	| ID của `Farm`                        	| String         	|
| sensors     	|     *    	| Danh sách ID `Sensor`                 | Array (String) 	|
| emails     	|     *    	| Danh sách Email (*)                  	| Array (Object) 	|
| phones     	|     *    	| Danh sách số điện thoại (*)          	| Array (Object) 	|
| content    	|     *    	| Nội dung (*)                         	| Object (JSON)  	|
| type       	|     *    	| Loại `Alert`: 0(_Alarm_), 1(_Khác_)   | Integer        	|
| status       	|     *    	| Trạng thái của `Alert` (*)            | Integer        	|
| createdAt  	|          	| Thời điểm tạo `Alert`                	| Datetime       	|
| modifiedAt 	|          	| Thời điểm cuối cùng cập nhật `Alert` 	| Datetime       	|

_(*) Chú thích:_
```
emails: [
    {
        address: string,
        status: boolean
    }
]

phones: [
    {
        number: string,
        status: boolean
    }
]

content: {
    email: string,
    phone: string
}

status: mã hóa theo dạng dãy 4 chữ số nhị phân (abcd) (1:True - 0:False), lần lượt:
- a: đã gửi thành công cho toàn bộ email
- b: đã gửi thành công cho ít nhất 1 email
- c: đã gửi tin nhắn thành công cho toàn bộ số điện thoại
- d: đã gửi tin nhắn thành công cho ít nhất 1 số điện thoại

```

# <a name="monitor-farm"></a>Monitor Farm
Chức năng theo dõi dữ liệu cập nhật `SensorData` được gửi từ Hub, cho phép:
- Theo dõi bản tin mới nhất với thời gian thực
- Kiểm tra, tách lọc các bản tin hiện có
- Hiển thị dưới dạng biểu đồ
- Xem thông tin chi tiết mỗi bản tin

__Bảng SensorData:__

| Field       	| Required 	| Description                        	| Data Type 	|
|-------------	|:--------:	|------------------------------------	|-----------	|
| ID          	|     *    	| ID của `SensorData`                	| Long      	|
| sensorId    	|     *    	| ID của `Sensor`                    	| String    	|
| temperature 	|          	| Nhiệt độ                           	| Float     	|
| moisture    	|          	| Độ ẩm                              	| Float     	|
| pH          	|          	| Độ pH                              	| Float     	|
| battery     	|          	| Pin                                	| Float     	|
| note        	|          	| Chú thích phản hồi từ hệ thống     	| String    	|
| createdAt   	|          	| Thời điểm tạo bản ghi `SensorData` 	| Datetime  	|

# <a name="my-account"></a>My Account
Bao gồm:
- Đăng ký/ Đăng nhập
- Chỉnh sửa thông tin cá nhân
- Đổi mật khẩu
- Reset mật khẩu
- Đổi Email (đồng thời là tên đăng nhập)

__Bảng User:__

| Field                	| Required 	| Description                                        	| Data Type       	|
|----------------------	|:--------:	|----------------------------------------------------	|-----------------	|
| ID                   	|     *    	| ID của `User`                                      	| Long           	|
| displayName          	|     *    	| Tên hiển thị                                       	| String          	|
| userEmail            	|     *    	| Email                                              	| String          	|
| userPassword         	|     *    	| Mật khẩu                                           	| Password        	|
| userPhone            	|     *    	| Số điện thoại                                      	| String          	|
| roles                	|          	| Danh sách các `Role`                               	| Array (Integer) 	|
| registerAt           	|          	| Thời điểm đăng ký                                  	| Date            	|
| profileImage         	|          	| Đường dẫn ảnh đại diện                             	| String          	|
| salt                 	|          	| Key mã hóa mật khẩu                                	| String          	|

__Bảng UserToken:__

| Field                	| Required 	| Description                                        	| Data Type       	|
|----------------------	|:--------:	|----------------------------------------------------	|-----------------	|
| ID                   	|     *    	| ID của `UserToken`                                    | Long           	|
| userId                |     *    	| ID của `User`                                      	| Long           	|
| resetPasswordExpires 	|          	| Thời điểm hết hạn token reset mật khẩu (Timestamp) 	| Integer         	|
| resetPasswordToken   	|          	| Token reset mật khẩu                               	| String          	|
| changeEmailExpires   	|          	| Thời điểm hết hạn token đổi Email (Timestamp)      	| Integer         	|
| changeEmailToken     	|          	| Token đổi Email                                    	| String          	|
| refreshTokenExpires   |          	| Thời điểm hết hạn refresh token (Timestamp)           | String          	|
| refreshToken     	    |          	| Token dùng để refresh access token                    | String          	|

# Admin Use Case:
- [Manage UserRoles](#manage-user-roles)
- [Manage Users](#manage-users)

# <a name="manage-user-roles"></a>Manage user roles
Quản lý phân quyền:
- Tạo role mới
- Xem/Chỉnh sửa role
- Xóa role

__Bảng UserRole:_

| Field       	| Required 	| Description         	| Data Type 	|
|-------------	|:--------:	|---------------------	|-----------	|
| ID          	|     *    	| ID của `UserRole`   	| Integer   	|
| name        	|          	| Tên `UserRole`      	| String    	|
| permissions 	|          	| Danh sách các quyền 	| Object    	|

# <a name="manage-users"></a>Manage users
Quản lý user:
- Tạo user mới
- Xem/Chỉnh sửa user
- Xóa user