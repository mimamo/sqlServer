USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_PmtType_Descr]    Script Date: 12/21/2015 15:49:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_PmtType_Descr]
	@CpnyID varchar(10),
	@PmtTypeID varchar(4)
AS
	SELECT	Descr
	FROM	PmtType
	WHERE	CpnyID = @CpnyID
	  AND	PmtTypeID = @PmtTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
