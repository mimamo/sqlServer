USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPrintQueue_GetFirstInv]    Script Date: 12/21/2015 15:36:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOPrintQueue_GetFirstInv]
	@CpnyID 	varchar(10),
	@RI_ID 		smallint

AS

	select	Min(InvcNbr)
	from	SOPrintQueue
	Where	CpnyID = @CpnyID
	  and	RI_ID = @RI_ID
	  and 	InvcNbr <> ''
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
