USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCMSite_Dflts]    Script Date: 12/21/2015 15:55:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCMSite_Dflts]
	@CpnyID Varchar(10),
	@SiteID Varchar(10)
AS
	Select  CpnyID,SiteID,DfltRepairBin,DfltVendorBin
	From 	Site
	Where 	CpnyID = @CpnyID
		And SiteID = @SiteID
	ORDER BY CpnyID,SiteId
GO
