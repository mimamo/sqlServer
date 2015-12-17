USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PIDetCostDelete]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_PIDetCostDelete]
	@PIID 	varchar(10),
	@Number int,
	@LineRef varchar(5)
AS
	DELETE FROM PIDetCost
	WHERE PIID LIKE @PIID AND
		Number LIKE @Number AND
		LineRef LIKE @LineRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
