USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormDefGetAllAccess]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormDefGetAllAccess]

   @CompanyKey INT
    
AS --Encrypt

/*
|| When			Who Rel			What
|| 08/22/2012   KMC 10.5.5.9    (148856) Created stored procedure to get the assigned tracking forms for a
||                              specific company key
*/

	SELECT sa.EntityKey as FormDefKey
		  ,sg.GroupName
	      ,sg.SecurityGroupKey
	  FROM tSecurityAccess sa (NOLOCK) inner join tSecurityGroup sg (NOLOCK) ON sa.SecurityGroupKey = sg.SecurityGroupKey 
	 WHERE sa.Entity = 'tFormDef'
	   and sa.EntityKey in (SELECT FormDefKey FROM tFormDef fd (nolock) WHERE fd.CompanyKey = @CompanyKey and fd.Active = 1)
  ORDER BY sg.GroupName

RETURN 1
GO
