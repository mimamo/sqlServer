USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessQueue_Count]    Script Date: 12/21/2015 14:17:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_ProcessQueue_Count]
AS
	SELECT 	count(*)
	FROM 	ProcessQueue


-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
