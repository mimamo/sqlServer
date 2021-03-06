USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_BinValid]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_BinValid]
	@SiteID varchar(10),
	@WhseLoc varchar(10),
	@ValidType varchar(10)
as
	declare @ReturnValue varchar(1)

	if upper(@ValidType) = 'ASSEMBLY' begin
		select	@ReturnValue = AssemblyValid
		from	LocTable
		where	SiteID = @SiteID
		and	WhseLoc = @WhseLoc
	end

	if upper(@ValidType) = 'RECEIPTS' begin
		select	@ReturnValue = ReceiptsValid
		from	LocTable
		where	SiteID = @SiteID
		and	WhseLoc = @WhseLoc
	end

	if upper(@ValidType) = 'SALES' begin
		select	@ReturnValue = SalesValid
		from	LocTable
		where	SiteID = @SiteID
		and	WhseLoc = @WhseLoc
	end

	select @ReturnValue

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
