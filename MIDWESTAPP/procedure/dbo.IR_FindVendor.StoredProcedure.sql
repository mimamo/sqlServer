USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[IR_FindVendor]    Script Date: 12/21/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IR_FindVendor] @InvtID VarChar(30), @SiteID varchar(15) as
Select
	IRPrimaryVendID As 'VendID'
From
	IRItemSiteReplenVar
Where
	InvtID = @InvtID
	And SiteID = @SiteID
GO
