# 设备管理系统部署文档

## 1. 部署环境准备

### 1.1 硬件要求
*   **CPU**: 2核及以上
*   **内存**: 4GB及以上
*   **硬盘**: 50GB及以上可用空间
*   **网络**: 需具备公网IP（如需公网访问）或局域网互通

### 1.2 软件环境依赖
在服务器上需预先安装以下软件：

| 软件名称 | 版本要求 | 用途 |
| --- | --- | --- |
| **JDK** | OpenJDK 21+ | 后端运行环境 |
| **MySQL** | 8.0+ | 数据存储 |
| **Redis** | 6.0+ | 缓存服务（可选，推荐安装）|
| **Nginx** | 1.18+ | 前端静态资源服务器 & 反向代理 |
| **Node.js** | 18+ | 前端编译构建（仅构建机需要） |

---

## 2. 数据库部署

### 2.1 初始化数据库
1.  登录 MySQL 数据库：
    ```bash
    mysql -u root -p
    ```
2.  创建数据库 `device`：
    ```sql
    CREATE DATABASE device DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    ```
3.  导入初始化脚本：
    将项目源码中 `backend/src/main/resources/db` 目录下的 SQL 脚本（如 `schema.sql` 和 `data.sql`）导入数据库。
    ```bash
    mysql -u root -p device < schema.sql
    ```

### 2.2 Redis 配置 (可选)
如果使用 Redis，请确保 Redis 服务已启动并设置了密码（推荐）。修改配置文件 `/etc/redis/redis.conf`，设置 `requirepass your_password`，并确保 `bind 0.0.0.0` 以允许远程连接（注意安全组配置）。

---

## 3. 后端服务部署 (Java / Spring Boot)

### 3.1 修改配置文件
在打包前，请检查 `backend/src/main/resources/application.yml` 中的配置是否与生产环境一致：
*   **数据库连接**: 修改 `spring.datasource.url`, `username`, `password`。
*   **Redis连接**: 修改 `spring.data.redis.host`, `password`。
*   **端口**: 默认 `8080`，如有冲突请修改。

### 3.2 编译打包
在 `backend` 目录下执行 Maven 打包命令：
```bash
cd backend
# 跳过测试并打包
mvn clean package -DskipTests
```
打包成功后，在 `backend/target` 目录下会生成一个 `.jar` 文件（例如 `device-control-system-0.0.1-SNAPSHOT.jar`）。

### 3.3 启动服务
将 jar 包上传至服务器 `/opt/device-control/backend` 目录，执行以下命令启动：

```bash
# 后台启动并将日志输出到文件
nohup java -jar device-control-system-0.0.1-SNAPSHOT.jar > app.log 2>&1 &
```

**检查启动状态**:
```bash
tail -f app.log
```
当看到 `Started DeviceControlApplication in ...` 字样时，表示启动成功。

---

## 4. 前端服务部署 (Vue 3 / Nginx)

### 4.1 修改生产环境配置
确保前端请求的 API 地址指向生产环境后端。
检查 `frontend/.env.production` 文件（如果没有则创建），设置：
```properties
VITE_API_BASE_URL=http://<你的服务器IP>:8080/api
```
或者在 `frontend/vite.config.js` 中配置代理，但在生产环境通常由 Nginx 处理。

### 4.2 编译构建
在 `frontend` 目录下执行构建命令：
```bash
cd frontend
npm install
npm run build
```
构建完成后，会生成 `frontend/dist` 目录，包含所有静态资源。

### 4.3 配置 Nginx
1.  将 `dist` 目录下的所有文件上传至服务器 `/opt/device-control/frontend`。
2.  编辑 Nginx 配置文件 `/etc/nginx/conf.d/device-control.conf`：

```nginx
server {
    listen 80;
    server_name your_domain_or_ip; # 替换为你的域名或IP

    # 前端静态资源
    location / {
        root /opt/device-control/frontend;
        try_files $uri $uri/ /index.html; # History 模式路由支持
        index index.html;
    }

    # 后端接口反向代理
    location /api/ {
        proxy_pass http://localhost:8080/api/; # 转发到后端端口
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

3.  重启 Nginx：
    ```bash
    nginx -t  # 检查配置语法
    systemctl reload nginx
    ```

---

## 5. Docker 容器化部署 (推荐)

如果服务器安装了 Docker 和 Docker Compose，可以使用以下方式快速部署。

1.  在项目根目录创建 `docker-compose.yml`：

```yaml
version: '3'
services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/device
      - SPRING_DATASOURCE_PASSWORD=root_password
    depends_on:
      - mysql
      - redis

  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: device
    volumes:
      - mysql_data:/var/lib/mysql

  redis:
    image: redis:6.0
    command: redis-server --requirepass your_redis_password

volumes:
  mysql_data:
```

2.  执行一键启动：
    ```bash
    docker-compose up -d --build
    ```

---

## 6. 验证与维护

*   访问 `http://<你的服务器IP>`，确认能够看到登录页面。
*   尝试登录系统，确认能正常获取数据。
*   **日志查看**：
    *   后端日志：`tail -f /opt/device-control/backend/logs/device-control.log`
    *   Nginx日志：`/var/log/nginx/error.log`

## 7. 故障排查

*   **Error: Network Error**: 检查 Nginx 的 `/api/` 代理配置是否正确，以及后端服务是否运行。
*   **404 Not Found (刷新页面)**: 检查 Nginx 是否配置了 `try_files $uri $uri/ /index.html;`。
*   **数据库连接拒绝**: 检查数据库防火墙或 MySQL 的 `bind-address` 配置。
