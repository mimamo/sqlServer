USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOSetup_PM]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SOSetup_PM]
as
--	select	convert(smallint, S4Future11)	-- PlanScheds
	select	convert(smallint, '1')		-- PlanScheds
	from	SOSetup (nolock)
GO
