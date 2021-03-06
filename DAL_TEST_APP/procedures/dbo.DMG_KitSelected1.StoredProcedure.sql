USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_KitSelected1]    Script Date: 12/21/2015 13:56:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_KitSelected1]
	@KitID 		varchar(30),
	@ExpKitDet 	smallint OUTPUT,
	@KitType	varchar(1) OUTPUT
as
	select	@ExpKitDet = ExpKitDet,
		@KitType = KitType
	from	Kit (NOLOCK)
	where	Kit.KitId = @KitID

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
