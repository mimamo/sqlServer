USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_KSite_KStatus_Seq]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Kit_KSite_KStatus_Seq] @parm1 varchar ( 30), @parm2 varchar ( 10), @parm3 varchar ( 1), @parm4beg varchar (5), @parm4end varchar (5) as
            Select * from Component where
			Kitid = @parm1 and
			KitSiteId = @parm2 and
			KitStatus = @parm3 and
			Sequence between @parm4beg and @parm4end and
			Status = 'A' and
			(SubKitStatus = 'N' or SubKitStatus = 'A' or SubKitStatus = '')
            Order by Kitid, KitSiteId, KitStatus, Sequence
GO
