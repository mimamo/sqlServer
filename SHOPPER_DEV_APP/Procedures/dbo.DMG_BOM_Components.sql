USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BOM_Components]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_BOM_Components]
	@KitID		varchar(30),
	@KitSiteID	varchar(10),
	@KitStatus	varchar(1),
	@MinSeq		varchar(5)

as
	select CmpnentID, SiteID, CmpnentQty, StockUsage,
		Status, Sequence,
		startDate, stopDate, SubKitStatus,
		KitID, KitSiteID, KitStatus
	from Component (NOLOCK)
		where  KitID = @KitID
		and KitSiteID = @KitSiteID
		and KitStatus = @KitStatus
		and Sequence >= @MinSeq

	order by KitID, SiteID, Sequence
GO
