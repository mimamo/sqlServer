USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smInvoice_DocType_ServCallID]    Script Date: 12/21/2015 13:45:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smInvoice_DocType_ServCallID]
		@parm1	varchar(10)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smInvoice
	WHERE
		DocType = 'S'
			AND
		DocumentID = @parm1
			AND
		RefNbr LIKE  @parm2

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
