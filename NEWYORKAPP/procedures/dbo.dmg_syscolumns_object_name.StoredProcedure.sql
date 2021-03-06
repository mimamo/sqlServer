USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[dmg_syscolumns_object_name]    Script Date: 12/21/2015 16:00:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[dmg_syscolumns_object_name] @parm1 varchar(80), @parm2 varchar(20) as

select * from syscolumns
inner join sysobjects ON sysobjects.id = syscolumns.id
where sysobjects.sysstat & 0xf = 3 and sysobjects.name = @parm1 and syscolumns.name like @parm2
and syscolumns.name in (select ValidName from DMG_SoShipHeader_ValidName)
order by syscolumns.name
GO
