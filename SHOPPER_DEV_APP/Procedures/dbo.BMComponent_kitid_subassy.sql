USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMComponent_kitid_subassy]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[BMComponent_kitid_subassy] @KitId varchar (30), @Site varchar (10), @Parm3 varchar (30) as
	Select DISTINCT CmpnentId from Component where
		Kitid = @KitID and
		KitSiteid = @Site and
		CmpnentId like @Parm3 and
		Status = 'A' and
		SubKitStatus <> 'N'
	order by Component.CmpnentId
GO
