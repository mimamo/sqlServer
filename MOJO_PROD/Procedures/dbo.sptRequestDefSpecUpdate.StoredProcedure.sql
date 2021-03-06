USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefSpecUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefSpecUpdate]
	@RequestDefSpecKey int,
	@RequestDefKey int,
	@FieldSetKey int,
	@Subject varchar(200),
	@Description varchar(500)

AS --Encrypt

	UPDATE
		tRequestDefSpec
	SET
		RequestDefKey = @RequestDefKey,
		FieldSetKey = @FieldSetKey,
		Subject = @Subject,
		Description = @Description
	WHERE
		RequestDefSpecKey = @RequestDefSpecKey 

	RETURN 1
GO
