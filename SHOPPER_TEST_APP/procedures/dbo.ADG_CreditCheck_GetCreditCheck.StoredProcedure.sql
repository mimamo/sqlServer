USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_CreditCheck_GetCreditCheck]    Script Date: 12/21/2015 16:06:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_CreditCheck_GetCreditCheck]
as
	select		CreditCheck
	from		SOSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
