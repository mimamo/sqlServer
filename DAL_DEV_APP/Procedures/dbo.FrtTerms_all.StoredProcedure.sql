USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FrtTerms_all]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FrtTerms_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM FrtTerms
	WHERE FrtTermsID LIKE @parm1
	ORDER BY FrtTermsID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
