USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRReplen_Find_ForItem]    Script Date: 12/21/2015 15:49:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRReplen_Find_ForItem] @InvtID VarChar(30), @SiteID VarChar(10) As
Select
	ReplMthd,Buyer,IRSourceCode,IRTransferSiteID,IRPrimaryVendID,ShipViaID
From
	IRItemSiteReplenVar
Where
	InvtID = @InvtID
	And SiteID = @SiteID
GO
