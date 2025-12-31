import request from '@/utils/request'

// 获取设备列表
export function getDeviceList(params) {
    return request({
        url: '/device/list',
        method: 'get',
        params
    })
}

// 添加设备
export function addDevice(data) {
    return request({
        url: '/device/add',
        method: 'post',
        data
    })
}

// 更新设备
export function updateDevice(data) {
    return request({
        url: '/device/update',
        method: 'put',
        data
    })
}

// 删除设备
export function deleteDevice(id) {
    return request({
        url: `/device/${id}`,
        method: 'delete'
    })
}

// 获取设备详情
export function getDeviceDetail(id) {
    return request({
        url: `/device/${id}`,
        method: 'get'
    })
}
