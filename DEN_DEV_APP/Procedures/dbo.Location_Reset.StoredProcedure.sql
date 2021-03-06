USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_Reset]    Script Date: 12/21/2015 14:06:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_Reset    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Location_Reset]
	@PIID		varchar(10)
as

	Update 	Location set Selected = 0
	From    Location Join PIDetail (NoLock)
			On Location.InvtID = PIDetail.InvtID
			And Location.SiteID = PIDetail.SiteID
			And Location.WhseLoc = PIDetail.WhseLoc
	where 	Location.selected = 1
	  And	Location.CountStatus = 'P'
	  And	PIDetail.PIID = @PIID

	Update	Location Set CountStatus = 'A', Selected = 0
	Where	CountStatus = 'P' and Selected = 1
GO
