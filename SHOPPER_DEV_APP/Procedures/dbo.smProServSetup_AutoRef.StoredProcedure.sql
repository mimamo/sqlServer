USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_AutoRef]    Script Date: 12/21/2015 14:34:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smProServSetup_AutoRef]
AS
	SELECT
		LastServiceCall
	FROM
		smProServSetup

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
