USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetInclQtyAvail_LocTable]    Script Date: 12/21/2015 16:06:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ADG_GetInclQtyAvail_LocTable]
	@SiteID		Varchar(10),
	@WhseLoc	Varchar(10)
As

SELECT	InclQtyAvail
	FROM	LocTable (NOLOCK)
	WHERE	SiteID = @SiteID AND WhseLoc = @WhseLoc
GO
