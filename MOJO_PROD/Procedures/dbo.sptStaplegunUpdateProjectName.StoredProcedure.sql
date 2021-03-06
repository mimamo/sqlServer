USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptStaplegunUpdateProjectName]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptStaplegunUpdateProjectName]
	@ProjectKey Int,
	@ProjectName varchar(100)
	
AS -- Encrypt
/*
  || When     Who Rel	  What
  || 10/09/13 WDF 10.573  (183959) Created for Staplegun API
*/

Declare @OldProjectName varchar(100)

	SELECT @OldProjectName = ProjectName 
	  FROM tProject (NOLOCK) 
	 WHERE 
	     ProjectKey = @ProjectKey

	If @ProjectName = @OldProjectName
	   RETURN 2

	Update tProject
	   set ProjectName =  @ProjectName
	WHERE 
		ProjectKey = @ProjectKey

	RETURN 1
GO
