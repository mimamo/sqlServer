USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_CmpId_Site_Stat_KStat]    Script Date: 12/21/2015 13:44:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_CmpId_Site_Stat_KStat] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1), @parm4 varchar ( 1) as
            Select * from Component where CmpnentId = @parm1 And siteid = @parm2 and
                status = @parm3 and Kitstatus = @parm4
                order by CmpnentId, siteid, status, kitstatus
GO
