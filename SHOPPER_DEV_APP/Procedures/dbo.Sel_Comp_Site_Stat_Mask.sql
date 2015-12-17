USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Sel_Comp_Site_Stat_Mask]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Sel_Comp_Site_Stat_Mask] @parm1 varchar ( 30),@parm2 varchar (10), @parm3 varchar (1) as
	Select * from Component where Cmpnentid like @parm1 and siteid like
        @parm2 and status like @parm3
        order by Cmpnentid,Siteid,Status
GO
