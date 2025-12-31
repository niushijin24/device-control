package com.example.devicecontrol.service;

import com.example.devicecontrol.entity.SysMenu;
import com.example.devicecontrol.mapper.SysMenuMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 菜单服务
 */
@Service
@RequiredArgsConstructor
public class SysMenuService {

    private final SysMenuMapper menuMapper;

    /**
     * 根据角色ID获取菜单树
     *
     * @param roleId 角色ID
     * @return 菜单树
     */
    public List<SysMenu> getMenuTreeByRoleId(Long roleId) {
        // 查询角色的所有菜单
        List<SysMenu> allMenus = menuMapper.selectMenuListByRoleId(roleId);

        // 构建树形结构
        return buildMenuTree(allMenus, 0L);
    }

    /**
     * 构建菜单树
     *
     * @param menuList 菜单列表
     * @param parentId 父菜单ID
     * @return 菜单树
     */
    private List<SysMenu> buildMenuTree(List<SysMenu> menuList, Long parentId) {
        List<SysMenu> tree = new ArrayList<>();

        for (SysMenu menu : menuList) {
            if (parentId.equals(menu.getParentId())) {
                // 递归查找子菜单
                List<SysMenu> children = buildMenuTree(menuList, menu.getId());
                if (!children.isEmpty()) {
                    menu.setChildren(children);
                }
                tree.add(menu);
            }
        }

        return tree;
    }

    /**
     * 获取所有菜单列表
     *
     * @return 菜单列表
     */
    public List<SysMenu> getAllMenuList() {
        return menuMapper.selectList(null);
    }

    /**
     * 获取菜单树（所有菜单）
     *
     * @return 菜单树
     */
    public List<SysMenu> getAllMenuTree() {
        List<SysMenu> allMenus = menuMapper.selectList(null);
        return buildMenuTree(allMenus, 0L);
    }
}
