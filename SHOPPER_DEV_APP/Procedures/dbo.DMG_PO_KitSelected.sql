USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_KitSelected]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_KitSelected]
	@KitID 		varchar(30),
	@ExpKitDet 	smallint OUTPUT,
	@KitType	varchar(1) OUTPUT
as
	select	@ExpKitDet = ExpKitDet,
		@KitType = ltrim(rtrim(KitType))
	from	Kit (NOLOCK)
	where	KitId = @KitID

	if @@ROWCOUNT = 0 begin
		set @ExpKitDet = 0
		set @KitType = ''
		return 0	--Failure
	end
	else begin
		--select @ExpKitDet
		return 1	--Success
	end
GO
