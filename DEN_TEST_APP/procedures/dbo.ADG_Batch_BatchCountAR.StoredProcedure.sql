USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Batch_BatchCountAR]    Script Date: 12/21/2015 15:36:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_Batch_BatchCountAR]
	@BatNbr	varchar(10)
as
	select		count(*)
	from		ARDoc
	where		BatNbr = @BatNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
