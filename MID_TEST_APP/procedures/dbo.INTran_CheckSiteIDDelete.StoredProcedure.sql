USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_CheckSiteIDDelete]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[INTran_CheckSiteIDDelete]
	@parmSiteID varchar (10)
as

	Select 	Count(*)
	From 	INTran
	where 	SiteID = @parmSiteID
	  and	Rlsed = 0
GO
