USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOSetup_PM]    Script Date: 12/21/2015 13:44:43 ******/
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
