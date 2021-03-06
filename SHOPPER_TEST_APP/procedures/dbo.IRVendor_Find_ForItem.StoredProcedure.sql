USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRVendor_Find_ForItem]    Script Date: 12/21/2015 16:07:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRVendor_Find_ForItem]
	@InvtID VarChar(30),
	@SiteID VarChar(10)
As
Select
-- Need the convert and case, as need to get no result when replen policy is not in 1,2
	Convert(Char(15),(Case When ReplMthd in (1,2) Then IRPrimaryVendID Else '' End)) As 'ReplMthd'
From
	IRItemSiteReplenVar
Where
	InvtID = @InvtID
	and SiteID = @SiteID
GO
