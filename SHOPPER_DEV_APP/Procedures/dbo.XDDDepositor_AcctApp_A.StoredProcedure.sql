USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDDepositor_AcctApp_A]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDDepositor_AcctApp_A]
As

	UPDATE	XDDDepositor
	SET	AcctAppStatus = 'A'
GO
