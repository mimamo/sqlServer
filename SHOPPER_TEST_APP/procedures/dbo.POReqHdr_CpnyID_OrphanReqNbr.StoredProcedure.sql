USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReqHdr_CpnyID_OrphanReqNbr]    Script Date: 12/21/2015 16:07:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReqHdr_CpnyID_OrphanReqNbr]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POReqHdr
	WHERE CpnyID = @parm1
	  	AND PONbr Not In (SELECT PONbr FROM PurchOrd WHERE CpnyID = @parm1)

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
