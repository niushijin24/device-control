package com.example.devicecontrol.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.devicecontrol.dto.LoginRequest;
import com.example.devicecontrol.entity.SysRole;
import com.example.devicecontrol.entity.SysUser;
import com.example.devicecontrol.mapper.SysRoleMapper;
import com.example.devicecontrol.mapper.SysUserMapper;
import com.example.devicecontrol.util.JwtUtil;
import com.example.devicecontrol.vo.LoginResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 认证服务
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    /**
     * 用户登录
     *
     * @param request 登录请求
     * @return 登录响应
     */
    public LoginResponse login(LoginRequest request) {
        // 查询用户
        LambdaQueryWrapper<SysUser> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysUser::getUsername, request.getUsername());
        SysUser user = userMapper.selectOne(queryWrapper);

        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 验证密码
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 检查用户状态
        if (user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用");
        }

        // 查询角色信息
        SysRole role = null;
        if (user.getRoleId() != null) {
            role = roleMapper.selectById(user.getRoleId());
        }

        // 生成Token
        String token = jwtUtil.generateToken(user.getUsername(), user.getId());

        // 更新最后登录时间和IP（这里简化处理，实际应从请求中获取IP）
        user.setLastLoginTime(LocalDateTime.now());
        userMapper.updateById(user);

        // 构建响应
        LoginResponse response = new LoginResponse();
        response.setToken(token);
        response.setUserId(user.getId());
        response.setUsername(user.getUsername());
        response.setRealName(user.getRealName());
        response.setAvatar(user.getAvatar());
        if (role != null) {
            response.setRoleCode(role.getRoleCode());
            response.setRoleName(role.getRoleName());
        }

        return response;
    }

    /**
     * 获取当前登录用户信息
     *
     * @param userId 用户ID
     * @return 用户信息
     */
    public SysUser getCurrentUser(Long userId) {
        return userMapper.selectById(userId);
    }
}
