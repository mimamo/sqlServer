USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConAdjust_ContractID_Tr1]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConAdjust_ContractID_Tr1]
	@parm1 varchar( 10 ),
	@parm2min smalldatetime, @parm2max smalldatetime,
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM smConAdjust
	WHERE ContractID LIKE @parm1
	   AND TransDate BETWEEN @parm2min AND @parm2max
	   AND Batnbr LIKE @parm3
	ORDER BY ContractID,
	   TransDate,
	   Batnbr

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
