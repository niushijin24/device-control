import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/login',
            name: 'Login',
            component: () => import('../views/Login.vue'),
            meta: { requiresAuth: false }
        },
        {
            path: '/',
            name: 'Layout',
            component: () => import('../views/Layout.vue'),
            redirect: '/dashboard',
            meta: { requiresAuth: true },
            children: [
                {
                    path: '/dashboard',
                    name: 'Dashboard',
                    component: () => import('../views/Dashboard.vue'),
                    meta: { title: '首页' }
                },
                {
                    path: '/device/list',
                    name: 'DeviceList',
                    component: () => import('../views/device/DeviceList.vue'),
                    meta: { title: '设备列表' }
                },
                {
                    path: '/system/user',
                    name: 'SystemUser',
                    component: () => import('../views/system/User.vue'),
                    meta: { title: '用户管理' }
                },
                {
                    path: '/system/menu',
                    name: 'SystemMenu',
                    component: () => import('../views/system/Menu.vue'),
                    meta: { title: '菜单管理' }
                }
            ]
        }
    ]
})

// 路由守卫
router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')

    if (to.meta.requiresAuth && !token) {
        next('/login')
    } else if (to.path === '/login' && token) {
        next('/')
    } else {
        next()
    }
})

export default router
