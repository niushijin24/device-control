# 技术栈说明

## 后端技术栈

### 核心框架
- **Spring Boot 3.x**（兼容 JDK 21）
- **Spring Security** - 安全认证和授权
- **Spring Data JPA** - 数据持久化
- **MyBatis-Plus** - 可选的 ORM 框架（推荐）

### 数据库
- **MySQL 8.0+** - 主数据库
- **Redis** - 缓存和会话管理（推荐）

### 依赖管理
- **Maven** 或 **Gradle**

### 推荐的依赖库
```xml
<!-- Spring Boot Starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- Spring Security -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- MySQL Driver -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
</dependency>

<!-- MyBatis-Plus -->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.5</version>
</dependency>

<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.3</version>
</dependency>

<!-- Validation -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>

<!-- Lombok -->
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>

<!-- WebSocket (可选，用于实时监控) -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>

<!-- Redis (可选) -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

### JDK 版本
- **JDK 21** (LTS)

---

## 前端技术栈

### 核心框架
- **Vue.js 3.x** - 渐进式 JavaScript 框架
- **Vue Router** - 路由管理
- **Pinia** - 状态管理（Vue 3 推荐）

### 构建工具
- **Vite** - 快速的前端构建工具

### UI 组件库
推荐使用以下之一：
- **Element Plus** - 基于 Vue 3 的组件库（推荐）
- **Ant Design Vue** - 企业级 UI 设计语言
- **Naive UI** - 轻量级 Vue 3 组件库

### 图表库
- **ECharts** - 强大的数据可视化库

### HTTP 客户端
- **Axios** - Promise 基于的 HTTP 客户端

### 工具库
- **Day.js** - 轻量级日期处理库
- **Lodash** - JavaScript 实用工具库

### 样式方案
- **SCSS/SASS** - CSS 预处理器
- 或 **原生 CSS** + CSS Variables

### 推荐的依赖
```json
{
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.2.0",
    "pinia": "^2.1.0",
    "element-plus": "^2.5.0",
    "axios": "^1.6.0",
    "echarts": "^5.4.0",
    "dayjs": "^1.11.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0",
    "sass": "^1.69.0"
  }
}
```

---

## 开发环境要求

### 后端
- JDK 21
- Maven 3.8+ 或 Gradle 8+
- MySQL 8.0+
- Redis 6+ (可选)
- IDE: IntelliJ IDEA (推荐) 或 Eclipse

### 前端
- Node.js 18+ (推荐 LTS 版本)
- npm 9+ 或 pnpm 8+
- IDE: VS Code (推荐) 或 WebStorm

---

## 项目结构建议

### 后端项目结构
```
device-control-backend/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── devicecontrol/
│   │   │               ├── DeviceControlApplication.java
│   │   │               ├── config/          # 配置类
│   │   │               ├── controller/      # 控制器
│   │   │               ├── service/         # 业务逻辑
│   │   │               ├── mapper/          # 数据访问层
│   │   │               ├── entity/          # 实体类
│   │   │               ├── dto/             # 数据传输对象
│   │   │               ├── vo/              # 视图对象
│   │   │               ├── common/          # 公共类
│   │   │               ├── exception/       # 异常处理
│   │   │               └── util/            # 工具类
│   │   └── resources/
│   │       ├── application.yml              # 配置文件
│   │       ├── mapper/                      # MyBatis XML
│   │       └── db/
│   │           └── migration/               # 数据库迁移脚本
│   └── test/
├── pom.xml                                  # Maven 配置
└── README.md
```

### 前端项目结构
```
device-control-frontend/
├── public/                  # 静态资源
├── src/
│   ├── assets/             # 资源文件（图片、样式等）
│   ├── components/         # 公共组件
│   ├── views/              # 页面组件
│   ├── router/             # 路由配置
│   ├── store/              # 状态管理
│   ├── api/                # API 接口
│   ├── utils/              # 工具函数
│   ├── styles/             # 全局样式
│   ├── App.vue             # 根组件
│   └── main.js             # 入口文件
├── index.html
├── vite.config.js          # Vite 配置
├── package.json
└── README.md
```

---

## API 设计规范

### RESTful API 风格
- **GET** - 查询资源
- **POST** - 创建资源
- **PUT** - 更新资源（全量）
- **PATCH** - 更新资源（部分）
- **DELETE** - 删除资源

### 统一响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1703845200000
}
```

### 接口示例
```
# 设备管理
GET    /api/devices              # 获取设备列表
GET    /api/devices/{id}         # 获取设备详情
POST   /api/devices              # 创建设备
PUT    /api/devices/{id}         # 更新设备
DELETE /api/devices/{id}         # 删除设备

# 设备操作
POST   /api/devices/{id}/restart # 重启设备
POST   /api/devices/{id}/start   # 启动设备
POST   /api/devices/{id}/stop    # 停止设备

# 监控数据
GET    /api/devices/{id}/monitor # 获取监控数据

# 告警管理
GET    /api/alerts               # 获取告警列表
PUT    /api/alerts/{id}/handle   # 处理告警
```

---

## 安全配置

### JWT 认证流程
1. 用户登录 -> 验证用户名密码
2. 生成 JWT Token -> 返回给前端
3. 前端存储 Token -> localStorage 或 sessionStorage
4. 请求时携带 Token -> Authorization: Bearer {token}
5. 后端验证 Token -> 解析用户信息

### 密码加密
- 使用 **BCrypt** 加密存储密码
- 密码强度要求：至少8位，包含字母、数字

### CORS 配置
- 开发环境：允许所有来源
- 生产环境：配置白名单

---

## 部署建议

### 开发环境
- 后端：`mvn spring-boot:run` 或 IDE 直接运行
- 前端：`npm run dev`

### 生产环境
- 后端：打包为 JAR，使用 `java -jar` 运行或部署到 Tomcat
- 前端：`npm run build` 构建静态文件，部署到 Nginx
- 数据库：独立 MySQL 服务器
- 反向代理：Nginx

### Docker 部署（推荐）
- 使用 Docker Compose 编排服务
- 容器化部署，便于扩展和维护



![alt text](image.png)