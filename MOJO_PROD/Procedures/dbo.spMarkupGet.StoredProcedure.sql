USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spMarkupGet]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMarkupGet]

	(
		@ProjectKey INT,
		@TaskID VARCHAR(30),
		@Type VARCHAR(20)
	)

AS --Encrypt
	DECLARE @TaskKey INT
         ,@Markup DECIMAL (9, 3)
         	

		EXEC @TaskKey = spTaskIDValidate @TaskID, @ProjectKey, 2
		
		SELECT @Markup = Markup
		FROM   tTask (NOLOCK)
		WHERE  TaskKey = @TaskKey	
	

	
	IF @Markup IS NULL
		SELECT @Markup = 0
		
	SELECT @Markup AS Markup
	
	/* set nocount on */
	return 1
GO
