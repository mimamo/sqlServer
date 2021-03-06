USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_KitSite_KStat_A]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Kit_KitSite_KStat_A] @parm1 varchar ( 30), @parm2 varchar ( 10),
		@parm3 varchar ( 1), @parm4 varchar ( 30), @parm5 varchar (1) as
        Select * from Component where
        	Kitid = @parm1 and
		KitSiteid = @parm2 and
        	Kitstatus = @parm3 and
		cmpnentid like @parm4 and
        	status = @parm5
        Order by Kitid,KitSiteid,Kitstatus,LineNbr,Cmpnentid
GO
