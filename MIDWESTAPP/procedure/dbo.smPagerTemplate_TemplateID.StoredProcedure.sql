USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[smPagerTemplate_TemplateID]    Script Date: 12/21/2015 15:55:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smPagerTemplate_TemplateID]
		@parm1 varchar(10)
AS
	SELECT
		*
	FROM
		smPagerTemplate
	WHERE
		TemplateID LIKE @parm1
	ORDER BY
		TemplateID
		,FieldOrder

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
