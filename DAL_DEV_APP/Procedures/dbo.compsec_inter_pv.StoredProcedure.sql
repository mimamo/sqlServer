USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[compsec_inter_pv]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[compsec_inter_pv] @parm1 char(47), @parm2 char(47), @parm3 char(5), @parm4 char(1),@parm5 varchar(10),@parm6 varchar(10)
as
Select distinct ToCompany, CpnyName from vs_InterCompany, vs_share_pvcpny where (@parm1 = 'SYSADMIN' or (userid = @parm2 and scrn = @parm3 and seclevel >= @parm4)) and FromCompany = @parm5 and CpnyID = ToCompany and Module = 'ZZ'  and ToCompany Like @parm6 order by ToCompany
GO
