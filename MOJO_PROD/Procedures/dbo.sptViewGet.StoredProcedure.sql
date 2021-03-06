USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptViewGet]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptViewGet]
	@ViewKey int

AS --Encrypt
	-- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
	IF @ViewKey IS NULL
		SELECT *
		FROM	 tView (NOLOCK)

	ELSE

		SELECT *
		FROM tView (NOLOCK)
		WHERE
			ViewKey = @ViewKey

	RETURN 1
GO
