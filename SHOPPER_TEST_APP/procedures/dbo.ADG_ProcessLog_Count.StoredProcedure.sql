USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessLog_Count]    Script Date: 12/21/2015 16:06:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ProcessLog_Count]
AS
	SELECT 	max(ProcessLogID)
	FROM 	ProcessLog


-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
