USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_BatNbr]    Script Date: 12/21/2015 16:01:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurchOrd_BatNbr]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM PurchOrd
	WHERE BatNbr LIKE @parm1
	ORDER BY BatNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
