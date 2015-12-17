USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRItemSiteReplenVar_All]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRItemSiteReplenVar_All]
	@InvtID VarChar(30),
	@SiteID VarChar(10)
As
Select
	*
From
	IRItemSiteReplenVar
Where
	InvtID Like @InvtID
	And SiteID Like @SiteID
Order By
	InvtID,
	SiteID
GO
