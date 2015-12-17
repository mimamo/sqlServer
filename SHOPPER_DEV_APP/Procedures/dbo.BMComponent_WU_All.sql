USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BMComponent_WU_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[BMComponent_WU_All] @CmpnentID varchar (30), @Status varchar (1), @Site varchar (10) as
	Select * from Component where
		CmpnentID = @CmpnentID
		and Status = @Status
		and SiteID like @Site
		Order by Cmpnentid
GO
