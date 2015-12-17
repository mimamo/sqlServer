USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRItemSiteRep_SingItem]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Drop proc IRItemSiteReplenVar_SingleItem
CREATE Procedure [dbo].[IRItemSiteRep_SingItem] @InvtID VarChar(30), @SiteID Varchar(10) As
Select
	InvtID,
	IRPrimaryVendID,
	ReplMthd,
	IRSourceCode,
	SiteID
From
	IRItemSiteReplenVar
Where
	InvtID = @InvtID
	And SiteID Like @SiteID
Order By
	InvtID,
	SiteID
GO
