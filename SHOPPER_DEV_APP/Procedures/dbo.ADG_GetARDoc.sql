USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GetARDoc]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_GetARDoc]
	@CustID   char(15),
	@DocType  char(15),
	@RefNbr   char(10),
	@BatNbr   char(10),
	@BatSeq   int
AS

	select
		*
	from
		ARDoc
	where
		CustID = @CustID
	and
		DocType = @DocType
	and
		RefNbr = @RefNbr
	and
		BatNbr = @BatNbr
	and
		BatSeq = @BatSeq

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
