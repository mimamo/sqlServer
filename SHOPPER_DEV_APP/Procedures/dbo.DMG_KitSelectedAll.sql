USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_KitSelectedAll]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_KitSelectedAll]
	@KitID 		varchar(30)
as
	select 	ExpKitDet, KitType, SiteID, Status
	from	Kit (NOLOCK)
	where	Kit.KitId = @KitID
GO
