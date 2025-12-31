# 设备管理系统后端

## 项目说明
基于 Spring Boot 3.x + JDK 21 + MySQL 8 的设备管理系统后端服务。

## 技术栈
- **Spring Boot**: 3.2.1
- **JDK**: 21
- **数据库**: MySQL 8.0+
- **ORM**: MyBatis-Plus 3.5.5
- **安全**: Spring Security + JWT
- **工具**: Lombok, Hutool

## 项目结构
```
backend/
├── src/main/java/com/example/devicecontrol/
│   ├── DeviceControlApplication.java    # 启动类
│   ├── config/                          # 配置类
│   │   ├── MyBatisPlusMetaObjectHandler.java
│   │   └── SecurityConfig.java
│   ├── controller/                      # 控制器
│   │   └── AuthController.java
│   ├── service/                         # 服务层
│   │   ├── AuthService.java
│   │   └── SysMenuService.java
│   ├── mapper/                          # 数据访问层
│   │   ├── SysUserMapper.java
│   │   ├── SysRoleMapper.java
│   │   └── SysMenuMapper.java
│   ├── entity/                          # 实体类
│   │   ├── SysUser.java
│   │   ├── SysRole.java
│   │   ├── SysMenu.java
│   │   ├── SysPermission.java
│   │   └── Device.java
│   ├── dto/                             # 数据传输对象
│   │   └── LoginRequest.java
│   ├── vo/                              # 视图对象
│   │   └── LoginResponse.java
│   ├── common/                          # 公共类
│   │   └── Result.java
│   ├── util/                            # 工具类
│   │   └── JwtUtil.java
│   └── exception/                       # 异常处理
│       └── GlobalExceptionHandler.java
└── src/main/resources/
    ├── application.yml                  # 配置文件
    └── mapper/                          # MyBatis XML
        └── SysMenuMapper.xml
```

## 快速开始

### 1. 数据库准备
```bash
# 导入数据库
mysql -u root -p < ../database/schema.sql
```

### 2. 修改配置
编辑 `src/main/resources/application.yml`，修改数据库连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/device_control?...
    username: root
    password: your_password
```

### 3. 运行项目
```bash
# 使用Maven运行
mvn spring-boot:run

# 或者使用IDE直接运行 DeviceControlApplication.java
```

### 4. 访问接口
- 基础路径: `http://localhost:8080/api`
- 登录接口: `POST /api/auth/login`

## API接口

### 认证接口

#### 1. 用户登录
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

响应：
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "userId": 1,
    "username": "admin",
    "realName": "系统管理员",
    "avatar": null,
    "roleCode": "SUPER_ADMIN",
    "roleName": "超级管理员"
  },
  "timestamp": 1703845200000
}
```

#### 2. 获取用户信息
```http
GET /api/auth/userInfo
Authorization: Bearer {token}
```

#### 3. 获取用户菜单
```http
GET /api/auth/menus
Authorization: Bearer {token}
```

#### 4. 退出登录
```http
POST /api/auth/logout
Authorization: Bearer {token}
```

## 默认账号
- 用户名: `admin`
- 密码: `admin123`

## 开发说明

### 添加新的实体类
1. 在 `entity` 包下创建实体类
2. 使用 `@TableName` 注解指定表名
3. 使用 `@TableId` 注解指定主键
4. 使用 `@TableField` 注解配置字段映射

### 添加新的接口
1. 在 `mapper` 包下创建 Mapper 接口
2. 在 `service` 包下创建 Service 类
3. 在 `controller` 包下创建 Controller 类
4. 使用 `Result` 类统一返回格式

## 注意事项
1. JWT Secret 需要在生产环境中修改
2. 数据库密码需要修改为实际密码
3. 日志文件路径需要根据实际情况调整
