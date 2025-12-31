package com.example.devicecontrol.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.devicecontrol.entity.SysMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 菜单Mapper接口
 */
@Mapper
public interface SysMenuMapper extends BaseMapper<SysMenu> {

    /**
     * 根据角色ID查询菜单列表
     *
     * @param roleId 角色ID
     * @return 菜单列表
     */
    List<SysMenu> selectMenuListByRoleId(@Param("roleId") Long roleId);
}
