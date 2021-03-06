USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_KitSelected]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_KitSelected]
	@KitID varchar(30),
	@DfltSite varchar(10) OUTPUT,
	@TranStatusCode varchar(2) OUTPUT
as
	select	@DfltSite = Inventory.DfltSite,
		@TranStatusCode = Inventory.TranStatusCode
	from	Kit (NOLOCK)
	join	Inventory (NOLOCK) on Inventory.InvtID = Kit.KitID
	where	Kit.KitId = @KitID
	and	Kit.Status = 'A'
	and	Inventory.TranStatusCode in ('AC','NP','OH')

	if @@ROWCOUNT = 0 begin
		set @DfltSite = ''
		set @TranStatusCode = ''
		return 0	--Failure
	end
	else begin
		--select @DfltSite, @TranStatusCode
		return 1	--Success
	end
GO
