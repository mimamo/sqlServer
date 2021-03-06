USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCBPostingValidateProjectPercent]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCBPostingValidateProjectPercent]
	(
		@CBBatchKey INT
	)
AS	-- Encrypt

	SET NOCOUNT ON
	
	IF EXISTS (SELECT 1
				FROM (
					SELECT b.ProjectKey
					,ISNULL((SELECT SUM(perc.Percentage) FROM tCBCodePercent perc (NOLOCK) WHERE perc.Entity = 'tProject' AND perc.EntityKey = b.ProjectKey)				
					       , 0) AS TotalPercent
					 FROM       
						(SELECT	DISTINCT cp.ProjectKey			
						FROM	tCBPosting cp (NOLOCK)
						WHERE	cp.CBBatchKey = @CBBatchKey) AS b
					) AS a
				WHERE a.TotalPercent <> 100
				)	
		RETURN 0
	
	ELSE
	
		RETURN 1
GO
