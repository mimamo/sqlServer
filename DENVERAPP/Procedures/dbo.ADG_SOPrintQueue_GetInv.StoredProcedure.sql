USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPrintQueue_GetInv]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOPrintQueue_GetInv]
	@CpnyID 	varchar(10),
	@RI_ID 		smallint,
	@InvcNbr	varchar(15)

AS

	select	*
	from	SOPrintQueue
	Where	CpnyID = @CpnyID
	  and	RI_ID = @RI_ID
	  and 	InvcNbr = @InvcNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
