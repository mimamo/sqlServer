USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smInvoice_DocType_ServCallID]    Script Date: 12/16/2015 15:55:34 ******/
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
