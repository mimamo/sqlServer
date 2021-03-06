USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPrintQueue_GetLastInv]    Script Date: 12/16/2015 15:55:11 ******/
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
