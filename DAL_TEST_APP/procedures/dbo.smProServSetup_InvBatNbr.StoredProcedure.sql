USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_InvBatNbr]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smProServSetup_InvBatNbr]
AS
	SELECT
		LastInvBatNbr
	FROM
		smProServSetup

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
