USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOPrintControl_Delete]    Script Date: 12/21/2015 13:56:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOPrintControl_Delete]
	@CpnyID varchar(10),
	@SOTypeID varchar(4)
AS
	DELETE FROM SOPrintControl
	WHERE CpnyID = @CpnyID AND
		SOTypeID = @SOTypeID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
