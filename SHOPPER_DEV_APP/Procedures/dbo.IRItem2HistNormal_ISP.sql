USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRItem2HistNormal_ISP]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRItem2HistNormal_ISP]
	@InvtID VarChar(30),
	@SiteID VarChar(10),
	@Period VarChar(6)
As
Select
	*
From
	IRItem2HistNormal
Where
	InvtID = @InvtID
	And SiteID = @SiteID
	And Period = @Period
GO
