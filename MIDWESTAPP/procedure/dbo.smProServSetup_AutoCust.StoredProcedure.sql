USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_AutoCust]    Script Date: 12/21/2015 15:55:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smProServSetup_AutoCust]
AS
	SELECT
		LastCustId
	FROM
		smProServSetup

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
