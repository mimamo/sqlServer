USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Location]    Script Date: 12/21/2015 15:43:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_Location]
	@InvtID		VarChar(30),
	@SiteID		VarChar(10),
	@WhseLoc	VarChar(10)
As
	Select	*
		From	Location (NoLock)
		Where	InvtID = @InvtID
			And SiteID = @SiteID
			And WhseLoc = @WhseLoc
GO
