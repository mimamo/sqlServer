USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_SOSetup]    Script Date: 12/21/2015 15:49:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ProcessMgr_SOSetup]
as
	select	AutoCreateShippers
	from	SOSetup (nolock)
GO
