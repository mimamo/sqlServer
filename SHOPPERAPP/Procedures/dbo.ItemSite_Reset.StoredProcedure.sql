USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_Reset]    Script Date: 12/21/2015 16:13:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_Reset    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[ItemSite_Reset]
	@PIID		varchar(10)
as

	Update 	ItemSite set Selected = 0
	From    ItemSite Join PIDetail (NoLock)
			On ItemSite.InvtID = PIDetail.InvtID
			And ItemSite.SiteID = PIDetail.SiteID
	where 	ItemSite.selected = 1
	  And	ItemSite.CountStatus = 'P'
	  And	PIDetail.PIID = @PIID

	Update	ItemSite Set CountStatus = 'A', Selected = 0
	Where	CountStatus = 'P' and Selected = 1
GO
