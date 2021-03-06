USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefGetAllAccess]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptRequestDefGetAllAccess]

   @CompanyKey INT
    
AS --Encrypt

/*
|| When			Who Rel			What
|| 08/22/2012   KMC 10.5.5.9    (148856) Created stored procedure to get the assigned project request forms for a
||                              specific company key
*/

	SELECT sa.EntityKey as RequestDefKey
		  ,sg.GroupName
	      ,sg.SecurityGroupKey
	  FROM tSecurityAccess sa (NOLOCK) 
		inner join tSecurityGroup sg (NOLOCK) ON sa.SecurityGroupKey = sg.SecurityGroupKey
	 WHERE sa.Entity = 'tRequestDef'
	   and sa.EntityKey in (SELECT RequestDefKey FROM tRequestDef rd (nolock) WHERE rd.CompanyKey = @CompanyKey and rd.Active = 1)
  ORDER BY sg.GroupName
 
 RETURN 1
GO
