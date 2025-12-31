package com.example.devicecontrol.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.devicecontrol.entity.Device;
import com.example.devicecontrol.entity.DeviceType;
import com.example.devicecontrol.mapper.DeviceMapper;
import com.example.devicecontrol.mapper.DeviceTypeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

/**
 * 设备管理服务
 */
@Service
@RequiredArgsConstructor
public class DeviceService {

    private final DeviceMapper deviceMapper;
    private final DeviceTypeMapper deviceTypeMapper;

    /**
     * 分页查询设备列表
     */
    public Page<Device> getDeviceList(Integer page, Integer size, String deviceName, String status) {
        Page<Device> pageInfo = new Page<>(page, size);
        LambdaQueryWrapper<Device> queryWrapper = new LambdaQueryWrapper<>();

        if (StringUtils.hasText(deviceName)) {
            queryWrapper.like(Device::getDeviceName, deviceName)
                    .or()
                    .like(Device::getDeviceCode, deviceName);
        }

        if (StringUtils.hasText(status)) {
            queryWrapper.eq(Device::getStatus, Integer.parseInt(status));
        }

        queryWrapper.orderByDesc(Device::getCreatedAt);
        Page<Device> result = deviceMapper.selectPage(pageInfo, queryWrapper);

        // 填充设备类型名称和编码
        if (!result.getRecords().isEmpty()) {
            result.getRecords().forEach(device -> {
                DeviceType type = deviceTypeMapper.selectById(device.getDeviceTypeId());
                if (type != null) {
                    device.setDeviceTypeName(type.getTypeName());
                    device.setDeviceType(type.getTypeCode());
                }
            });
        }
        return result;
    }

    /**
     * 添加设备
     */
    public void addDevice(Device device) {
        // 检查设备编码是否存在
        Long count = deviceMapper.selectCount(new LambdaQueryWrapper<Device>()
                .eq(Device::getDeviceCode, device.getDeviceCode()));
        if (count > 0) {
            throw new RuntimeException("设备编码已存在");
        }

        resolveDeviceType(device);

        // 设置默认状态
        if (device.getStatus() == null) {
            device.setStatus(0); // 默认离线
        }

        deviceMapper.insert(device);
    }

    /**
     * 更新设备
     */
    public void updateDevice(Device device) {
        if (device.getId() == null) {
            throw new RuntimeException("设备ID不能为空");
        }
        resolveDeviceType(device);
        deviceMapper.updateById(device);
    }

    private void resolveDeviceType(Device device) {
        // 处理设备类型
        if (device.getDeviceTypeId() == null && StringUtils.hasText(device.getDeviceType())) {
            DeviceType type = deviceTypeMapper.selectOne(
                    new LambdaQueryWrapper<DeviceType>()
                            .eq(DeviceType::getTypeCode, device.getDeviceType()));
            if (type != null) {
                device.setDeviceTypeId(type.getId());
            } else {
                throw new RuntimeException("无效的设备类型: " + device.getDeviceType());
            }
        }

        if (device.getDeviceTypeId() == null) {
            throw new RuntimeException("请选择设备类型");
        }
    }

    /**
     * 删除设备
     */
    public void deleteDevice(Long id) {
        deviceMapper.deleteById(id);
    }

    /**
     * 获取设备详情
     */
    public Device getDeviceById(Long id) {
        return deviceMapper.selectById(id);
    }
}
