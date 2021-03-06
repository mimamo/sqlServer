USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[compsec_active_pv]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[compsec_active_pv] @parm1 char(47), @parm2 char(47), @parm3 char(5), @parm4 char(1),@parm5 varchar(10)
as
select distinct cpnyname,databasename,active,cpnyid from vs_share_pvcpny where (@parm1 = 'SYSADMIN' or (userid = @parm2 and scrn = @parm3 and seclevel >= @parm4)) and active = 1 and cpnyid like @parm5 order by cpnyid
GO
