<template>
  <div class="device-list">
    <el-card>
      <template #header>
        <div class="card-header">
          <div class="header-left">
            <el-input
              v-model="queryParams.deviceName"
              placeholder="搜索设备名称/编码"
              class="search-input"
              clearable
              @clear="handleSearch"
              @keyup.enter="handleSearch"
            >
              <template #append>
                <el-button @click="handleSearch"><el-icon><Search /></el-icon></el-button>
              </template>
            </el-input>
          </div>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>添加设备
          </el-button>
        </div>
      </template>
      
      <el-table 
        v-loading="loading" 
        :data="deviceList" 
        style="width: 100%"
        border
        stripe
      >
        <el-table-column prop="deviceName" label="设备名称" min-width="120" />
        <el-table-column prop="deviceCode" label="设备编码" min-width="120" />
        <el-table-column prop="deviceTypeName" label="设备类型" width="100">
          <template #default="scope">
            <el-tag effect="plain">{{ scope.row.deviceTypeName || scope.row.deviceType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="ipAddress" label="IP地址" width="140" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '在线' : '离线' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="updatedAt" label="最后更新" width="180" />
        <el-table-column label="操作" :width="isMobile ? 120 : 200" fixed="right">
          <template #default="scope">
            <template v-if="!isMobile">
              <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
              <el-button 
                size="small" 
                type="danger" 
                @click="handleDelete(scope.row)"
              >删除</el-button>
            </template>
            <template v-else>
               <div class="mobile-actions">
                 <el-button size="small" type="primary" link :icon="Edit" @click="handleEdit(scope.row)"></el-button>
                 <el-button size="small" type="danger" link :icon="Delete" @click="handleDelete(scope.row)"></el-button>
               </div>
            </template>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryParams.page"
          v-model:page-size="queryParams.size"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 添加/编辑设备对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加设备' : '编辑设备'"
      width="500px"
      @close="resetForm"
    >
      <el-form
        ref="deviceFormRef"
        :model="deviceForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="设备名称" prop="deviceName">
          <el-input v-model="deviceForm.deviceName" placeholder="请输入设备名称" />
        </el-form-item>
        <el-form-item label="设备编码" prop="deviceCode">
          <el-input v-model="deviceForm.deviceCode" placeholder="请输入设备唯一编码" :disabled="dialogType === 'edit'" />
        </el-form-item>
        <el-form-item label="设备类型" prop="deviceType">
          <el-select v-model="deviceForm.deviceType" placeholder="请选择设备类型" style="width: 100%">
            <el-option label="服务器" value="SERVER" />
            <el-option label="路由器" value="ROUTER" />
            <el-option label="交换机" value="SWITCH" />
            <el-option label="摄像头" value="CAMERA" />
            <el-option label="传感器" value="SENSOR" />
            <el-option label="其他" value="OTHER" />
          </el-select>
        </el-form-item>
        <el-form-item label="IP地址" prop="ipAddress">
          <el-input v-model="deviceForm.ipAddress" placeholder="请输入IP地址" />
        </el-form-item>
        <el-form-item label="MAC地址" prop="macAddress">
          <el-input v-model="deviceForm.macAddress" placeholder="请输入MAC地址" />
        </el-form-item>
        <el-form-item label="备注" prop="description">
          <el-input type="textarea" v-model="deviceForm.description" placeholder="请输入备注信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitLoading">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount } from 'vue'
import { Search, Plus, Edit, Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getDeviceList, addDevice, updateDevice, deleteDevice } from '@/api/device'

const isMobile = ref(false)
const loading = ref(false)
const deviceList = ref([])
const total = ref(0)
const queryParams = reactive({
  page: 1,
  size: 10,
  deviceName: ''
})

// 表单相关
const dialogVisible = ref(false)
const dialogType = ref('add') // add or edit
const submitLoading = ref(false)
const deviceFormRef = ref(null)
const deviceForm = reactive({
  id: null,
  deviceName: '',
  deviceCode: '',
  deviceType: '',
  ipAddress: '',
  macAddress: '',
  description: ''
})

const rules = {
  deviceName: [{ required: true, message: '请输入设备名称', trigger: 'blur' }],
  deviceCode: [{ required: true, message: '请输入设备编码', trigger: 'blur' }],
  deviceType: [{ required: true, message: '请选择设备类型', trigger: 'change' }]
}

// 获取列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await getDeviceList(queryParams)
    deviceList.value = res.data.records
    total.value = res.data.total
  } catch (error) {
    console.error('获取设备列表失败', error)
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  queryParams.page = 1
  fetchList()
}

// 分页
const handleSizeChange = (val) => {
  queryParams.size = val
  fetchList()
}
const handleCurrentChange = (val) => {
  queryParams.page = val
  fetchList()
}

// 添加
const handleAdd = () => {
  dialogType.value = 'add'
  dialogVisible.value = true
  // 重置表单
  Object.keys(deviceForm).forEach(key => deviceForm[key] = '')
  deviceForm.id = null
}

// 编辑
const handleEdit = (row) => {
  dialogType.value = 'edit'
  dialogVisible.value = true
  // 填充表单
  Object.keys(deviceForm).forEach(key => {
    if (row[key] !== undefined) {
      deviceForm[key] = row[key]
    }
  })
}

// 删除
const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除设备 "${row.deviceName}" 吗？`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  ).then(async () => {
    try {
      await deleteDevice(row.id)
      ElMessage.success('删除成功')
      fetchList()
    } catch (error) {
      // 错误已统一处理
    }
  })
}

// 提交表单
const submitForm = async () => {
  if (!deviceFormRef.value) return
  
  await deviceFormRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        if (dialogType.value === 'add') {
          await addDevice(deviceForm)
          ElMessage.success('添加成功')
        } else {
          await updateDevice(deviceForm)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        fetchList()
      } catch (error) {
        // 错误已统一处理
      } finally {
        submitLoading.value = false
      }
    }
  })
}

// 重置表单
const resetForm = () => {
  if (deviceFormRef.value) {
    deviceFormRef.value.resetFields()
  }
}

const checkMobile = () => {
  const rect = document.body.getBoundingClientRect()
  isMobile.value = rect.width - 1 < 992
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
  fetchList()
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', checkMobile)
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-input {
  width: 300px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

@media screen and (max-width: 480px) {
  .card-header {
    flex-direction: column;
    align-items: stretch;
    gap: 10px;
  }
  
  .header-left {
    width: 100%;
  }
  
  .search-input {
    width: 100%;
  }
  
  .el-button {
    width: 100%;
  }
  
  .pagination-container {
    justify-content: center;
  }
  
  .mobile-actions {
    display: flex;
    justify-content: center;
    gap: 8px;
  }
}
</style>
