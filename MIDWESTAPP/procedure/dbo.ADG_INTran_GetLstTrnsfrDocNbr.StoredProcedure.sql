USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_GetLstTrnsfrDocNbr]    Script Date: 12/21/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_GetLstTrnsfrDocNbr]
as
	select		LstTrnsfrDocNbr
	from		INSetup

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
