USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smRentHeader_AutoNbr]    Script Date: 12/21/2015 16:13:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentHeader_AutoNbr]
AS
	SELECT
		LastTranID
	FROM
		smRentSetup

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
