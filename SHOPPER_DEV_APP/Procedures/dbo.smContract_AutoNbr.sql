USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_AutoNbr]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_AutoNbr]
AS
	SELECT
		LastContractNbr
	FROM
		smProServSetup

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
