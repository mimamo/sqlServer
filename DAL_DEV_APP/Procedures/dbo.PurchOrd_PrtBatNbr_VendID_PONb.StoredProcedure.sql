USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_PrtBatNbr_VendID_PONb]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurchOrd_PrtBatNbr_VendID_PONb]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM PurchOrd
	WHERE PrtBatNbr LIKE @parm1
	   AND VendID LIKE @parm2
	   AND PONbr LIKE @parm3
	ORDER BY PrtBatNbr,
	   VendID,
	   PONbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
