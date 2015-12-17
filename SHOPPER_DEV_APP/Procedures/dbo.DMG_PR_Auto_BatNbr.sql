USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PR_Auto_BatNbr]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[DMG_PR_Auto_BatNbr](
	@CpnyID   char(10),
	@NumTries smallint
)AS
	declare @Status	smallint
	declare	@DocID	char(10)
	declare @Width	smallint

	EXEC DMG_PR_Auto_BatNbr_OP @CpnyID, @NumTries, @Status OUTPUT, @DocID OUTPUT, @Width OUTPUT

	-- Return the parameters as a result set
	select Status = @Status, DocID = @DocID, Width = @Width

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
