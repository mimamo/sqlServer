USE [DEN_DEV_APP]
GO
/****** Object:  View [dbo].[IRWrkDemand_Rollup]    Script Date: 12/21/2015 14:05:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- The following creates a view from the temp table. It contains records only for those bottom nodes that do not supply to other nodes 

Create	View [dbo].[IRWrkDemand_Rollup]
As
Select	InvtID, FromSiteID, SiteID
	From	IRWrkItemSite (NoLock)
	Where	Len(RTrim(FromSiteID)) > 0
		And Processed = 0
		And SiteID Not In (Select FromSiteID From IRWrkItemSite Site (NoLock) 
					Where Site.InvtID = IRWrkItemSite.InvtID 
						And Processed = 0 And Len(RTrim(FromSiteID)) > 0)
GO
