USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRISReplenVar_SingDaySupply]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRISReplenVar_SingDaySupply]
	@InvtID VarChar(30),
	@SiteID VarChar(10)
As
Select
	IRDaysSupply
From
	IRItemSiteReplenVar
Where
	InvtID = @InvtID
	And SiteID = @SiteID
GO
