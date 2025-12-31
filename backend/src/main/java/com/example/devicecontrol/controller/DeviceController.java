package com.example.devicecontrol.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.devicecontrol.common.Result;
import com.example.devicecontrol.entity.Device;
import com.example.devicecontrol.service.DeviceService;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 设备管理控制器
 */
@RestController
@RequestMapping("/device")
@RequiredArgsConstructor
public class DeviceController {

    private final DeviceService deviceService;

    /**
     * 获取设备列表
     */
    @GetMapping("/list")
    public Result<Page<Device>> getList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String deviceName,
            @RequestParam(required = false) String status) {
        return Result.success(deviceService.getDeviceList(page, size, deviceName, status));
    }

    /**
     * 添加设备
     */
    @PostMapping("/add")
    public Result<String> add(@RequestBody @Validated Device device) {
        deviceService.addDevice(device);
        return Result.success("添加成功");
    }

    /**
     * 更新设备
     */
    @PutMapping("/update")
    public Result<String> update(@RequestBody @Validated Device device) {
        deviceService.updateDevice(device);
        return Result.success("更新成功");
    }

    /**
     * 删除设备
     */
    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        deviceService.deleteDevice(id);
        return Result.success("删除成功");
    }

    /**
     * 获取设备详情
     */
    @GetMapping("/{id}")
    public Result<Device> getDetail(@PathVariable Long id) {
        return Result.success(deviceService.getDeviceById(id));
    }
}
