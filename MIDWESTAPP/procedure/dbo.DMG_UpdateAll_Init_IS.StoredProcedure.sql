USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Init_IS]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Init_IS]
	@ComputerName		varchar(21),
	@InvtIDParm		varchar(30),
	@SiteIDParm		varchar(10)
as
	delete from SOPlan
	where InvtID like @InvtIDParm and SiteID like @SiteIDParm
		delete from INUpdateQty_Wrk
	where ComputerName = @ComputerName
GO
