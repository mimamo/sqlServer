USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_AutoNbr]    Script Date: 12/21/2015 15:43:10 ******/
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
