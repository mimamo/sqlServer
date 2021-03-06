USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_POID_GetPODocID]    Script Date: 12/21/2015 13:35:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[DMG_POID_GetPODocID](
	@CpnyID   char(10),
	@NumTries smallint
)AS
	declare @Status	smallint
	declare	@DocID	char(10)
	declare @Width	smallint

	EXEC DMG_POID_GetPODocID_OP @CpnyID, @NumTries, @Status OUTPUT, @DocID OUTPUT, @Width OUTPUT

	-- Return the parameters as a result set
	select Status = @Status, DocID = @DocID, Width = @Width

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
