USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProcessMgr_SOSetup]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_ProcessMgr_SOSetup]
	@AutoCreateShippers smallint OUTPUT
as
	set @AutoCreateShippers = 0
		select	@AutoCreateShippers = AutoCreateShippers
	from	SOSetup (NOLOCK)

	--select @AutoCreateShippers
GO
