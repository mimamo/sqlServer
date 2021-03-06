USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOHeader_CustOrdNbr]    Script Date: 12/21/2015 14:05:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOHeader_CustOrdNbr]
	@CpnyID varchar(10),
	@CustOrdNbr varchar(25)
AS
	SELECT *
	FROM SOHeader
	WHERE CpnyID = @CpnyID AND
		CustOrdNbr LIKE @CustOrdNbr
	ORDER BY CustOrdNbr, CustID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
