USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConSetup_all]    Script Date: 12/21/2015 15:37:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConSetup_all]
AS
	SELECT *
	FROM smConSetup
	ORDER BY
		SetUpID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
