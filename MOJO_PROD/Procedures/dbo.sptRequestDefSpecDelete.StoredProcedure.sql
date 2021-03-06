USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefSpecDelete]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefSpecDelete]
	@RequestDefSpecKey int

AS --Encrypt

Declare @DisplayOrder int
Declare @RequestDefKey int

	Select @DisplayOrder = DisplayOrder, @RequestDefKey = RequestDefKey from tRequestDefSpec (NOLOCK) Where RequestDefSpecKey = @RequestDefSpecKey

	DELETE
	FROM tRequestDefSpec
	WHERE
		RequestDefSpecKey = @RequestDefSpecKey

	Update tRequestDefSpec
	Set DisplayOrder = DisplayOrder - 1
	Where DisplayOrder > @DisplayOrder and
		RequestDefKey = @RequestDefKey

	RETURN 1
GO
