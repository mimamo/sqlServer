USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditInfo_CreditGracePct]    Script Date: 12/21/2015 13:35:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditInfo_CreditGracePct]
as
	select	CreditGracePct
	from	SOSetup (nolock)
GO
