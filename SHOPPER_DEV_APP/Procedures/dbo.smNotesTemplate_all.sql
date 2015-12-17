USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smNotesTemplate_all]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smNotesTemplate_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM smNotesTemplate
	WHERE TemplateID LIKE @parm1
	ORDER BY TemplateID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
