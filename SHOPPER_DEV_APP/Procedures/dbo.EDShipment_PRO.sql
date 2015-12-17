USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_PRO]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_PRO]
	@parm1 varchar( 30 )
AS
	SELECT *
	FROM EDShipment
	WHERE PRO LIKE @parm1
	ORDER BY PRO

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
