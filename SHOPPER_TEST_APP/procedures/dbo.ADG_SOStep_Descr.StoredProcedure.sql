USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOStep_Descr]    Script Date: 12/21/2015 16:06:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SOStep_Descr]
	@CpnyID varchar(10),
	@SOTypeID varchar(4),
	@FunctionID varchar(8),
	@FunctionClass varchar(4)
AS
	SELECT Descr
	FROM SOStep
	WHERE CpnyID = @CpnyID AND
		SOTypeID = @SOTypeID AND
		FunctionID = @FunctionID AND
		FunctionClass = @FunctionClass

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
