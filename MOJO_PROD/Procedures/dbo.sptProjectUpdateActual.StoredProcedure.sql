USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectUpdateActual]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectUpdateActual]
	@ProjectKey int,
	@StartDate smalldatetime,
	@CompleteDate smalldatetime,
	@StatusNotes varchar(100),
	@DetailedNotes varchar(4000),
	@ProjectStatusKey int

AS --Encrypt


Declare  @Active tinyint

	SELECT @Active = IsActive
	FROM tProjectStatus (NOLOCK) 
	WHERE ProjectStatusKey = @ProjectStatusKey
	
		
	Update tProject
	Set 
		ProjectStatusKey = @ProjectStatusKey,
		Active = @Active,
		StartDate = @StartDate,
		CompleteDate = @CompleteDate,
		StatusNotes = @StatusNotes,
		DetailedNotes = @DetailedNotes
	Where ProjectKey = @ProjectKey
	

	RETURN 1
GO
