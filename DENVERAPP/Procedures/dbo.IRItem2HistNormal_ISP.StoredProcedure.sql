USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRItem2HistNormal_ISP]    Script Date: 12/21/2015 15:42:56 ******/
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
