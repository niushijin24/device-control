package com.example.devicecontrol.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 设备实体类
 */
@Data
@TableName("device")
public class Device implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 设备ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 设备名称
     */
    private String deviceName;

    /**
     * 设备编码
     */
    private String deviceCode;

    /**
     * 设备类型ID
     */
    private Long deviceTypeId;

    /**
     * 所属分组ID
     */
    private Long groupId;

    /**
     * MAC地址
     */
    private String macAddress;

    /**
     * IP地址
     */
    private String ipAddress;

    /**
     * 端口号
     */
    private Integer port;

    /**
     * 设备位置
     */
    private String location;

    /**
     * 设备状态：0-离线，1-在线，2-故障，3-维护中
     */
    private Integer status;

    /**
     * 固件版本
     */
    private String firmwareVersion;

    /**
     * 软件版本
     */
    private String softwareVersion;

    /**
     * 制造商
     */
    private String manufacturer;

    /**
     * 设备型号
     */
    private String model;

    /**
     * 序列号
     */
    private String serialNumber;

    /**
     * 购买日期
     */
    private LocalDate purchaseDate;

    /**
     * 保修截止日期
     */
    private LocalDate warrantyDate;

    /**
     * 设备描述
     */
    private String description;

    /**
     * 备注
     */
    private String remark;

    /**
     * 配置数据（JSON格式）
     */
    private String configData;

    /**
     * 创建人ID
     */
    private Long createdBy;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 最后在线时间
     */
    private LocalDateTime lastOnlineTime;

    /**
     * 设备类型名称（非数据库字段）
     */
    @TableField(exist = false)
    private String deviceTypeName;

    /**
     * 分组名称（非数据库字段）
     */
    @TableField(exist = false)
    private String groupName;

    /**
     * 设备类型编码（非数据库字段，用于接收前端参数）
     */
    @TableField(exist = false)
    private String deviceType;
}
