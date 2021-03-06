USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefGetList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormDefGetList]
 @CompanyKey int
AS --Encrypt
 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 SELECT *,
		'WorkingLevelName' = 
			CASE WorkingLevel
				WHEN 1 THEN 'Company'
				ELSE 'Project'
			END,
		'FormTypeName' = 
			CASE FormType
				WHEN 1 THEN 'Workflow'
				ELSE 'Static'
			END
 FROM tFormDef (nolock)
 WHERE
  CompanyKey = @CompanyKey
 ORDER BY
  WorkingLevel, FormName
 RETURN 1
GO
