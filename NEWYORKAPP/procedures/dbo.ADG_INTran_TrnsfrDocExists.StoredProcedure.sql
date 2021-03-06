USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_INTran_TrnsfrDocExists]    Script Date: 12/21/2015 16:00:45 ******/
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
