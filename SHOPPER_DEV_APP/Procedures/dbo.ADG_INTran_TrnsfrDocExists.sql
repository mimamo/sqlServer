USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_TrnsfrDocExists]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_INTran_TrnsfrDocExists]
	@TrnsfrDocNbr	varchar(10)
as
	declare		@DocCount	integer
	declare		@DocExists	smallint

	select		@DocCount = count(*)
	from		TrnsfrDoc
	where		TrnsfrDocNbr = @TrnsfrDocNbr

	if (@DocCount > 0)
		select @DocExists = 1
	else
		select @DocExists = 0

	select @DocExists

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
