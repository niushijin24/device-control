package com.example.devicecontrol;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 设备管理系统启动类
 * 
 * @author Device Control Team
 * @version 1.0.0
 */
@SpringBootApplication
@MapperScan("com.example.devicecontrol.mapper")
public class DeviceControlApplication {

    public static void main(String[] args) {
        SpringApplication.run(DeviceControlApplication.class, args);
        System.out.println("""

                ====================================
                设备管理系统启动成功！
                访问地址: http://localhost:8080/api
                ====================================
                """);
    }
}
