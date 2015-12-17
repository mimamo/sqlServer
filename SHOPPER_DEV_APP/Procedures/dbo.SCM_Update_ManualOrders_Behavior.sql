USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Update_ManualOrders_Behavior]    Script Date: 12/16/2015 15:55:33 ******/
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
