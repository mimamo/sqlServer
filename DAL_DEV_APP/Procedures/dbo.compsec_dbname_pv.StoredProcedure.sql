USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[compsec_dbname_pv]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[compsec_dbname_pv] @parm1 char(47), @parm2 char(47), @parm3 char(5), @parm4 char(1),@parm5 varchar(50),@parm6 varchar(10)
as
Select distinct cpnyid, CpnyName from vs_share_pvcpny where (@parm1 = 'SYSADMIN' or (userid = @parm2 and scrn = @parm3 and seclevel >= @parm4)) and databasename = @parm5 and cpnyid Like @parm6 order by cpnyid
GO
