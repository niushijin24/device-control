import { defineStore } from 'pinia'
import { login as loginApi, getUserInfo, getUserMenus } from '@/api/auth'

export const useUserStore = defineStore('user', {
    state: () => ({
        token: localStorage.getItem('token') || '',
        userInfo: null,
        menus: []
    }),

    actions: {
        // 登录
        async login(loginForm) {
            try {
                const res = await loginApi(loginForm)
                this.token = res.data.token
                localStorage.setItem('token', res.data.token)
                return res
            } catch (error) {
                return Promise.reject(error)
            }
        },

        // 获取用户信息
        async getInfo() {
            try {
                const res = await getUserInfo()
                this.userInfo = res.data
                return res
            } catch (error) {
                return Promise.reject(error)
            }
        },

        // 获取菜单
        async getMenus() {
            try {
                const res = await getUserMenus()
                this.menus = res.data
                return res
            } catch (error) {
                return Promise.reject(error)
            }
        },

        // 退出登录
        logout() {
            this.token = ''
            this.userInfo = null
            this.menus = []
            localStorage.removeItem('token')
        }
    }
})
