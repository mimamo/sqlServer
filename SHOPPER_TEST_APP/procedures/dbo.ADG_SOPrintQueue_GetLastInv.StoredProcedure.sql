USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPrintQueue_GetLastInv]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOPrintQueue_GetLastInv]
	@CpnyID 	varchar(10),
	@RI_ID 		smallint

AS

	select	Max(InvcNbr)
	from	SOPrintQueue
	Where	CpnyID = @CpnyID
	  and	RI_ID = @RI_ID
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
