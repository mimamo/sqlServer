USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ProcessMgr_SOSetup]    Script Date: 12/21/2015 16:07:01 ******/
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
