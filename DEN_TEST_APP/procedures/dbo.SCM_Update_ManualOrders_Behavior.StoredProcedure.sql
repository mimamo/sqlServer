USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Update_ManualOrders_Behavior]    Script Date: 12/21/2015 15:37:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[SCM_Update_ManualOrders_Behavior]
AS
	UPDATE	SOType
	SET	Behavior = 'SO'
	WHERE	Behavior = 'MO'

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
