USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLookupValidateProject]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spLookupValidateProject]
	(
		@ProjectNumber VARCHAR(50),
		@CompanyKey INT
	)
AS --Encrypt
	DECLARE @LookupKey INT
	
			SELECT @LookupKey = ProjectKey 
			FROM 
				tProject p (nolock)
			WHERE p.CompanyKey = @CompanyKey -- Limit to the user's company
				AND  UPPER(LTRIM(RTRIM(p.ProjectNumber))) LIKE UPPER(LTRIM(RTRIM(@ProjectNumber)))
				
	
	IF @LookupKey IS NOT NULL	
		RETURN @LookupKey
	ELSE
		RETURN -1	
	
	/* set nocount on */
	return 1
GO
