USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMComponent_Kit_kitid_subassy]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMComponent_Kit_kitid_subassy] @KitId varchar (30), @Site varchar (10), @Parm3 varchar (30) as
	Select DISTINCT Component.CmpnentId from Component, Kit where
		Component.Kitid = @KitID and
		Component.KitSiteid = @Site and
		Component.CmpnentId like @Parm3 and
		Component.Status = 'A' and
		Component.SubKitStatus <> 'N' and
		Kit.KitId = Component.KitId
	order by Component.CmpnentId
GO
