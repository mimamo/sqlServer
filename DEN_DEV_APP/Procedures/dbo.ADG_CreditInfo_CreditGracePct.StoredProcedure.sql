USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditInfo_CreditGracePct]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditInfo_CreditGracePct]
as
	select	CreditGracePct
	from	SOSetup (nolock)
GO
