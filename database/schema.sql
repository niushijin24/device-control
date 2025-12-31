-- ====================================
-- 设备管理系统数据库表结构
-- 数据库: MySQL 8.0+
-- 字符集: utf8mb4
-- ====================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS device DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE device;

-- ====================================
-- 1. 用户表
-- ====================================
CREATE TABLE `sys_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码（加密）',
  `real_name` VARCHAR(50) COMMENT '真实姓名',
  `email` VARCHAR(100) COMMENT '邮箱',
  `phone` VARCHAR(20) COMMENT '手机号',
  `avatar` VARCHAR(255) COMMENT '头像URL',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `role_id` BIGINT COMMENT '角色ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_login_time` DATETIME COMMENT '最后登录时间',
  `last_login_ip` VARCHAR(50) COMMENT '最后登录IP',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ====================================
-- 2. 角色表
-- ====================================
CREATE TABLE `sys_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` VARCHAR(50) NOT NULL COMMENT '角色名称',
  `role_code` VARCHAR(50) NOT NULL COMMENT '角色编码',
  `description` VARCHAR(255) COMMENT '角色描述',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- ====================================
-- 3. 菜单表
-- ====================================
CREATE TABLE `sys_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` VARCHAR(50) NOT NULL COMMENT '菜单名称',
  `menu_code` VARCHAR(100) NOT NULL COMMENT '菜单编码',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单ID，0表示顶级菜单',
  `menu_type` TINYINT NOT NULL DEFAULT 1 COMMENT '菜单类型：1-目录，2-菜单，3-按钮',
  `path` VARCHAR(255) COMMENT '路由路径',
  `component` VARCHAR(255) COMMENT '组件路径',
  `redirect` VARCHAR(255) COMMENT '重定向路径',
  `icon` VARCHAR(100) COMMENT '菜单图标',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `is_hidden` TINYINT NOT NULL DEFAULT 0 COMMENT '是否隐藏：0-否，1-是',
  `is_cache` TINYINT NOT NULL DEFAULT 1 COMMENT '是否缓存：0-否，1-是',
  `is_external` TINYINT NOT NULL DEFAULT 0 COMMENT '是否外链：0-否，1-是',
  `permission_code` VARCHAR(100) COMMENT '权限标识',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `remark` VARCHAR(500) COMMENT '备注',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_menu_code` (`menu_code`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单表';

-- ====================================
-- 4. 权限表
-- ====================================
CREATE TABLE `sys_permission` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `permission_name` VARCHAR(50) NOT NULL COMMENT '权限名称',
  `permission_code` VARCHAR(100) NOT NULL COMMENT '权限编码',
  `permission_type` TINYINT NOT NULL COMMENT '权限类型：1-菜单权限，2-按钮权限，3-接口权限',
  `menu_id` BIGINT COMMENT '关联菜单ID',
  `api_path` VARCHAR(255) COMMENT 'API路径',
  `api_method` VARCHAR(20) COMMENT 'API方法：GET/POST/PUT/DELETE',
  `description` VARCHAR(500) COMMENT '权限描述',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_code` (`permission_code`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- ====================================
-- 5. 角色权限关联表
-- ====================================
CREATE TABLE `sys_role_permission` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `role_id` BIGINT NOT NULL COMMENT '角色ID',
  `permission_id` BIGINT NOT NULL COMMENT '权限ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ====================================
-- 6. 角色菜单关联表
-- ====================================
CREATE TABLE `sys_role_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `role_id` BIGINT NOT NULL COMMENT '角色ID',
  `menu_id` BIGINT NOT NULL COMMENT '菜单ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- ====================================
-- 7. 设备分组表
-- ====================================
CREATE TABLE `device_group` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分组ID',
  `group_name` VARCHAR(100) NOT NULL COMMENT '分组名称',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父分组ID，0表示顶级分组',
  `group_path` VARCHAR(500) COMMENT '分组路径，如：/1/2/3',
  `description` VARCHAR(500) COMMENT '分组描述',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `created_by` BIGINT COMMENT '创建人ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备分组表';

-- ====================================
-- 8. 设备类型表
-- ====================================
CREATE TABLE `device_type` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '设备类型ID',
  `type_name` VARCHAR(50) NOT NULL COMMENT '类型名称',
  `type_code` VARCHAR(50) NOT NULL COMMENT '类型编码',
  `icon` VARCHAR(255) COMMENT '图标',
  `description` VARCHAR(500) COMMENT '类型描述',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type_code` (`type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备类型表';

-- ====================================
-- 9. 设备信息表（核心表）
-- ====================================
CREATE TABLE `device` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '设备ID',
  `device_name` VARCHAR(100) NOT NULL COMMENT '设备名称',
  `device_code` VARCHAR(100) NOT NULL COMMENT '设备编码',
  `device_type_id` BIGINT NOT NULL COMMENT '设备类型ID',
  `group_id` BIGINT COMMENT '所属分组ID',
  `mac_address` VARCHAR(50) COMMENT 'MAC地址',
  `ip_address` VARCHAR(50) COMMENT 'IP地址',
  `port` INT COMMENT '端口号',
  `location` VARCHAR(255) COMMENT '设备位置',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '设备状态：0-离线，1-在线，2-故障，3-维护中',
  `firmware_version` VARCHAR(50) COMMENT '固件版本',
  `software_version` VARCHAR(50) COMMENT '软件版本',
  `manufacturer` VARCHAR(100) COMMENT '制造商',
  `model` VARCHAR(100) COMMENT '设备型号',
  `serial_number` VARCHAR(100) COMMENT '序列号',
  `purchase_date` DATE COMMENT '购买日期',
  `warranty_date` DATE COMMENT '保修截止日期',
  `description` TEXT COMMENT '设备描述',
  `remark` TEXT COMMENT '备注',
  `config_data` JSON COMMENT '配置数据（JSON格式）',
  `created_by` BIGINT COMMENT '创建人ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_online_time` DATETIME COMMENT '最后在线时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_device_code` (`device_code`),
  KEY `idx_device_type` (`device_type_id`),
  KEY `idx_group_id` (`group_id`),
  KEY `idx_status` (`status`),
  KEY `idx_ip_address` (`ip_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备信息表';

-- ====================================
-- 10. 设备监控数据表
-- ====================================
CREATE TABLE `device_monitor` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '监控记录ID',
  `device_id` BIGINT NOT NULL COMMENT '设备ID',
  `cpu_usage` DECIMAL(5,2) COMMENT 'CPU使用率（%）',
  `memory_usage` DECIMAL(5,2) COMMENT '内存使用率（%）',
  `disk_usage` DECIMAL(5,2) COMMENT '磁盘使用率（%）',
  `network_upload` BIGINT COMMENT '网络上行流量（KB）',
  `network_download` BIGINT COMMENT '网络下行流量（KB）',
  `temperature` DECIMAL(5,2) COMMENT '温度（℃）',
  `uptime` BIGINT COMMENT '运行时长（秒）',
  `custom_metrics` JSON COMMENT '自定义监控指标（JSON格式）',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备监控数据表';

-- ====================================
-- 11. 设备告警表
-- ====================================
CREATE TABLE `device_alert` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '告警ID',
  `device_id` BIGINT NOT NULL COMMENT '设备ID',
  `alert_type` VARCHAR(50) NOT NULL COMMENT '告警类型：offline-离线，cpu_high-CPU过高，memory_high-内存过高等',
  `alert_level` TINYINT NOT NULL COMMENT '告警级别：1-提示，2-警告，3-严重，4-紧急',
  `alert_title` VARCHAR(255) NOT NULL COMMENT '告警标题',
  `alert_content` TEXT COMMENT '告警内容',
  `alert_value` VARCHAR(100) COMMENT '告警值',
  `threshold_value` VARCHAR(100) COMMENT '阈值',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0-未处理，1-处理中，2-已处理，3-已忽略',
  `handled_by` BIGINT COMMENT '处理人ID',
  `handled_at` DATETIME COMMENT '处理时间',
  `handle_remark` TEXT COMMENT '处理备注',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '告警时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_alert_type` (`alert_type`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备告警表';

-- ====================================
-- 12. 设备操作日志表
-- ====================================
CREATE TABLE `device_operation_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `device_id` BIGINT COMMENT '设备ID',
  `operation_type` VARCHAR(50) NOT NULL COMMENT '操作类型：add-添加，edit-编辑，delete-删除，restart-重启，start-启动，stop-停止等',
  `operation_desc` VARCHAR(500) COMMENT '操作描述',
  `operator_id` BIGINT COMMENT '操作人ID',
  `operator_name` VARCHAR(50) COMMENT '操作人姓名',
  `ip_address` VARCHAR(50) COMMENT '操作IP',
  `request_params` TEXT COMMENT '请求参数',
  `response_result` TEXT COMMENT '响应结果',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-失败，1-成功',
  `error_msg` TEXT COMMENT '错误信息',
  `execution_time` INT COMMENT '执行时长（毫秒）',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_operation_type` (`operation_type`),
  KEY `idx_operator_id` (`operator_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备操作日志表';

-- ====================================
-- 13. 设备状态变更日志表
-- ====================================
CREATE TABLE `device_status_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `device_id` BIGINT NOT NULL COMMENT '设备ID',
  `old_status` TINYINT COMMENT '旧状态',
  `new_status` TINYINT NOT NULL COMMENT '新状态',
  `change_reason` VARCHAR(500) COMMENT '变更原因',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '变更时间',
  PRIMARY KEY (`id`),
  KEY `idx_device_id` (`device_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备状态变更日志表';

-- ====================================
-- 14. 系统配置表
-- ====================================
CREATE TABLE `sys_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
  `config_value` TEXT COMMENT '配置值',
  `config_type` VARCHAR(50) COMMENT '配置类型：string-字符串，number-数字，boolean-布尔，json-JSON',
  `description` VARCHAR(500) COMMENT '配置描述',
  `is_system` TINYINT NOT NULL DEFAULT 0 COMMENT '是否系统配置：0-否，1-是',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- ====================================
-- 15. 通知消息表
-- ====================================
CREATE TABLE `sys_notification` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `user_id` BIGINT NOT NULL COMMENT '接收用户ID',
  `title` VARCHAR(255) NOT NULL COMMENT '消息标题',
  `content` TEXT COMMENT '消息内容',
  `type` VARCHAR(50) COMMENT '消息类型：alert-告警，system-系统，operation-操作',
  `related_id` BIGINT COMMENT '关联ID（如告警ID、设备ID等）',
  `is_read` TINYINT NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
  `read_at` DATETIME COMMENT '阅读时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知消息表';

-- ====================================
-- 初始化数据
-- ====================================

-- 插入默认角色
INSERT INTO `sys_role` (`role_name`, `role_code`, `description`) VALUES
('超级管理员', 'SUPER_ADMIN', '拥有所有权限'),
('管理员', 'ADMIN', '系统管理员'),
('运维人员', 'OPERATOR', '设备运维人员'),
('普通用户', 'USER', '只读权限');

-- 插入默认管理员用户（密码：admin123，需要在应用层使用BCrypt加密）
INSERT INTO `sys_user` (`username`, `password`, `real_name`, `email`, `status`, `role_id`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'admin@example.com', 1, 1);

-- 插入默认设备类型
INSERT INTO `device_type` (`type_name`, `type_code`, `description`) VALUES
('服务器', 'SERVER', '服务器设备'),
('路由器', 'ROUTER', '网络路由器'),
('交换机', 'SWITCH', '网络交换机'),
('摄像头', 'CAMERA', '监控摄像头'),
('传感器', 'SENSOR', '物联网传感器'),
('工控机', 'IPC', '工业控制计算机'),
('其他', 'OTHER', '其他类型设备');

-- 插入默认设备分组
INSERT INTO `device_group` (`group_name`, `parent_id`, `group_path`, `description`) VALUES
('全部设备', 0, '/1', '所有设备的根分组'),
('机房A', 1, '/1/2', '机房A区域设备'),
('机房B', 1, '/1/3', '机房B区域设备'),
('办公区', 1, '/1/4', '办公区域设备');

-- 插入系统配置
INSERT INTO `sys_config` (`config_key`, `config_value`, `config_type`, `description`, `is_system`) VALUES
('system.name', '设备管理系统', 'string', '系统名称', 1),
('alert.email.enable', 'true', 'boolean', '是否启用邮件告警', 0),
('monitor.interval', '60', 'number', '监控数据采集间隔（秒）', 0),
('device.offline.threshold', '300', 'number', '设备离线判定阈值（秒）', 0);

-- 插入系统菜单
INSERT INTO `sys_menu` (`id`, `menu_name`, `menu_code`, `parent_id`, `menu_type`, `path`, `component`, `redirect`, `icon`, `sort_order`, `permission_code`, `status`) VALUES
-- 一级菜单
(1, '首页', 'dashboard', 0, 1, '/dashboard', 'Layout', '/dashboard/index', 'HomeFilled', 1, 'dashboard:view', 1),
(2, '设备管理', 'device', 0, 1, '/device', 'Layout', '/device/list', 'Monitor', 2, 'device:view', 1),
(3, '监控中心', 'monitor', 0, 1, '/monitor', 'Layout', '/monitor/dashboard', 'DataLine', 3, 'monitor:view', 1),
(4, '告警管理', 'alert', 0, 1, '/alert', 'Layout', '/alert/list', 'BellFilled', 4, 'alert:view', 1),
(5, '系统管理', 'system', 0, 1, '/system', 'Layout', '/system/user', 'Setting', 5, 'system:view', 1),

-- 首页子菜单
(101, '工作台', 'dashboard_index', 1, 2, '/dashboard/index', 'views/dashboard/index', NULL, 'DataBoard', 1, 'dashboard:index', 1),

-- 设备管理子菜单
(201, '设备列表', 'device_list', 2, 2, '/device/list', 'views/device/list', NULL, 'List', 1, 'device:list', 1),
(202, '设备分组', 'device_group', 2, 2, '/device/group', 'views/device/group', NULL, 'FolderOpened', 2, 'device:group', 1),
(203, '设备类型', 'device_type', 2, 2, '/device/type', 'views/device/type', NULL, 'Grid', 3, 'device:type', 1),

-- 监控中心子菜单
(301, '监控仪表盘', 'monitor_dashboard', 3, 2, '/monitor/dashboard', 'views/monitor/dashboard', NULL, 'Odometer', 1, 'monitor:dashboard', 1),
(302, '实时监控', 'monitor_realtime', 3, 2, '/monitor/realtime', 'views/monitor/realtime', NULL, 'View', 2, 'monitor:realtime', 1),

-- 告警管理子菜单
(401, '告警列表', 'alert_list', 4, 2, '/alert/list', 'views/alert/list', NULL, 'List', 1, 'alert:list', 1),
(402, '告警规则', 'alert_rule', 4, 2, '/alert/rule', 'views/alert/rule', NULL, 'DocumentChecked', 2, 'alert:rule', 1),
(403, '告警历史', 'alert_history', 4, 2, '/alert/history', 'views/alert/history', NULL, 'Clock', 3, 'alert:history', 1),

-- 系统管理子菜单
(501, '用户管理', 'system_user', 5, 2, '/system/user', 'views/system/user', NULL, 'User', 1, 'system:user', 1),
(502, '角色管理', 'system_role', 5, 2, '/system/role', 'views/system/role', NULL, 'UserFilled', 2, 'system:role', 1),
(503, '菜单管理', 'system_menu', 5, 2, '/system/menu', 'views/system/menu', NULL, 'Menu', 3, 'system:menu', 1),
(504, '权限管理', 'system_permission', 5, 2, '/system/permission', 'views/system/permission', NULL, 'Key', 4, 'system:permission', 1),
(505, '系统配置', 'system_config', 5, 2, '/system/config', 'views/system/config', NULL, 'Tools', 5, 'system:config', 1),
(506, '操作日志', 'system_log', 5, 2, '/system/log', 'views/system/log', NULL, 'Document', 6, 'system:log', 1),

-- 设备列表按钮权限
(2011, '添加设备', 'device_add', 201, 3, NULL, NULL, NULL, NULL, 1, 'device:add', 1),
(2012, '编辑设备', 'device_edit', 201, 3, NULL, NULL, NULL, NULL, 2, 'device:edit', 1),
(2013, '删除设备', 'device_delete', 201, 3, NULL, NULL, NULL, NULL, 3, 'device:delete', 1),
(2014, '设备详情', 'device_detail', 201, 3, NULL, NULL, NULL, NULL, 4, 'device:detail', 1),
(2015, '设备控制', 'device_control', 201, 3, NULL, NULL, NULL, NULL, 5, 'device:control', 1),
(2016, '批量导入', 'device_import', 201, 3, NULL, NULL, NULL, NULL, 6, 'device:import', 1),
(2017, '导出数据', 'device_export', 201, 3, NULL, NULL, NULL, NULL, 7, 'device:export', 1),

-- 用户管理按钮权限
(5011, '添加用户', 'user_add', 501, 3, NULL, NULL, NULL, NULL, 1, 'system:user:add', 1),
(5012, '编辑用户', 'user_edit', 501, 3, NULL, NULL, NULL, NULL, 2, 'system:user:edit', 1),
(5013, '删除用户', 'user_delete', 501, 3, NULL, NULL, NULL, NULL, 3, 'system:user:delete', 1),
(5014, '重置密码', 'user_reset_pwd', 501, 3, NULL, NULL, NULL, NULL, 4, 'system:user:resetPwd', 1),

-- 角色管理按钮权限
(5021, '添加角色', 'role_add', 502, 3, NULL, NULL, NULL, NULL, 1, 'system:role:add', 1),
(5022, '编辑角色', 'role_edit', 502, 3, NULL, NULL, NULL, NULL, 2, 'system:role:edit', 1),
(5023, '删除角色', 'role_delete', 502, 3, NULL, NULL, NULL, NULL, 3, 'system:role:delete', 1),
(5024, '分配权限', 'role_assign_permission', 502, 3, NULL, NULL, NULL, NULL, 4, 'system:role:assignPermission', 1),

-- 菜单管理按钮权限
(5031, '添加菜单', 'menu_add', 503, 3, NULL, NULL, NULL, NULL, 1, 'system:menu:add', 1),
(5032, '编辑菜单', 'menu_edit', 503, 3, NULL, NULL, NULL, NULL, 2, 'system:menu:edit', 1),
(5033, '删除菜单', 'menu_delete', 503, 3, NULL, NULL, NULL, NULL, 3, 'system:menu:delete', 1);

-- 插入权限数据（API接口权限）
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `permission_type`, `menu_id`, `api_path`, `api_method`, `description`, `status`) VALUES
-- 设备管理接口权限
('查询设备列表', 'device:list:query', 3, 201, '/api/devices', 'GET', '查询设备列表接口', 1),
('添加设备', 'device:add:api', 3, 201, '/api/devices', 'POST', '添加设备接口', 1),
('更新设备', 'device:edit:api', 3, 201, '/api/devices/*', 'PUT', '更新设备接口', 1),
('删除设备', 'device:delete:api', 3, 201, '/api/devices/*', 'DELETE', '删除设备接口', 1),
('设备详情', 'device:detail:api', 3, 201, '/api/devices/*', 'GET', '获取设备详情接口', 1),
('设备控制', 'device:control:api', 3, 201, '/api/devices/*/control', 'POST', '设备控制接口', 1),

-- 用户管理接口权限
('查询用户列表', 'user:list:query', 3, 501, '/api/users', 'GET', '查询用户列表接口', 1),
('添加用户', 'user:add:api', 3, 501, '/api/users', 'POST', '添加用户接口', 1),
('更新用户', 'user:edit:api', 3, 501, '/api/users/*', 'PUT', '更新用户接口', 1),
('删除用户', 'user:delete:api', 3, 501, '/api/users/*', 'DELETE', '删除用户接口', 1),

-- 角色管理接口权限
('查询角色列表', 'role:list:query', 3, 502, '/api/roles', 'GET', '查询角色列表接口', 1),
('添加角色', 'role:add:api', 3, 502, '/api/roles', 'POST', '添加角色接口', 1),
('更新角色', 'role:edit:api', 3, 502, '/api/roles/*', 'PUT', '更新角色接口', 1),
('删除角色', 'role:delete:api', 3, 502, '/api/roles/*', 'DELETE', '删除角色接口', 1),
('分配权限', 'role:assign:api', 3, 502, '/api/roles/*/permissions', 'POST', '角色分配权限接口', 1),

-- 菜单管理接口权限
('查询菜单列表', 'menu:list:query', 3, 503, '/api/menus', 'GET', '查询菜单列表接口', 1),
('添加菜单', 'menu:add:api', 3, 503, '/api/menus', 'POST', '添加菜单接口', 1),
('更新菜单', 'menu:edit:api', 3, 503, '/api/menus/*', 'PUT', '更新菜单接口', 1),
('删除菜单', 'menu:delete:api', 3, 503, '/api/menus/*', 'DELETE', '删除菜单接口', 1);

-- 为超级管理员分配所有菜单权限
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, id FROM `sys_menu` WHERE status = 1;

-- 为管理员分配除系统管理外的所有菜单
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 2, id FROM `sys_menu` WHERE status = 1 AND parent_id != 5 AND id != 5;

-- 为运维人员分配设备和监控相关菜单
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 3, id FROM `sys_menu` WHERE status = 1 AND (parent_id IN (1, 2, 3, 4) OR id IN (1, 2, 3, 4));

-- 为普通用户分配只读权限（首页、设备查看、监控查看）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 4, id FROM `sys_menu` WHERE status = 1 AND id IN (1, 101, 2, 201, 3, 301, 302);
