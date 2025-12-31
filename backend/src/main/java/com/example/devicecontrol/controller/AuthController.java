package com.example.devicecontrol.controller;

import com.example.devicecontrol.common.Result;
import com.example.devicecontrol.dto.LoginRequest;
import com.example.devicecontrol.entity.SysMenu;
import com.example.devicecontrol.entity.SysUser;
import com.example.devicecontrol.service.AuthService;
import com.example.devicecontrol.service.SysMenuService;
import com.example.devicecontrol.util.JwtUtil;
import com.example.devicecontrol.vo.LoginResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final SysMenuService menuService;
    private final JwtUtil jwtUtil;

    /**
     * 用户登录
     *
     * @param request 登录请求
     * @return 登录响应
     */
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse response = authService.login(request);
            return Result.success("登录成功", response);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 获取当前用户信息
     *
     * @param authorization Token
     * @return 用户信息
     */
    @GetMapping("/userInfo")
    public Result<SysUser> getUserInfo(@RequestHeader("Authorization") String authorization) {
        try {
            String token = authorization.replace("Bearer ", "");
            Long userId = jwtUtil.getUserIdFromToken(token);
            SysUser user = authService.getCurrentUser(userId);
            // 清空密码
            user.setPassword(null);
            return Result.success(user);
        } catch (Exception e) {
            return Result.error("获取用户信息失败");
        }
    }

    /**
     * 获取当前用户的菜单
     *
     * @param authorization Token
     * @return 菜单树
     */
    @GetMapping("/menus")
    public Result<List<SysMenu>> getUserMenus(@RequestHeader("Authorization") String authorization) {
        try {
            String token = authorization.replace("Bearer ", "");
            Long userId = jwtUtil.getUserIdFromToken(token);
            SysUser user = authService.getCurrentUser(userId);

            if (user == null || user.getRoleId() == null) {
                return Result.error("用户角色信息不存在");
            }

            List<SysMenu> menus = menuService.getMenuTreeByRoleId(user.getRoleId());
            return Result.success(menus);
        } catch (Exception e) {
            return Result.error("获取菜单失败");
        }
    }

    /**
     * 退出登录
     *
     * @return 响应结果
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        return Result.success("退出成功", null);
    }
}
