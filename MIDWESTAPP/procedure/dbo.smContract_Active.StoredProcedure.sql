USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_Active]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smContract_Active]
	@parm1 varchar(10)
AS
	SELECT * FROM smContract
	WHERE 	ContractId LIKE @parm1
		AND Status IN ('A','E','C')
	ORDER BY
		ContractId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
