USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerGet]
	@RetainerKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/05/07 GHL 8.5   Added GLCompanyName + AssignedProjects to lock GLCompany on UI 
  || 10/27/11 RLB 10549 (116487) Added fields for Flex 
  || 05/03/12 GHL 10555 (142325) Added CompanyID = GLCompanyID to temporarily fix bug
  || 08/22/12 RLB 10559 (87856) Added ContactName     
  || 12/20/13 WDF 10575 (198697) Added BillingManagerName
 */

	SELECT r.*
	      ,c.CustomerID
		  ,c.CompanyName	   
		  ,ISNULL(u.FirstName, '') + ' '+ ISNULL(u.LastName, '') AS InvoiceApprovedByName
		  ,ISNULL(u2.FirstName, '') + ' '+ ISNULL(u2.LastName, '') AS ContactName
		  ,ISNULL(u3.FirstName, '') + ' '+ ISNULL(u3.LastName, '') AS BillingManagerName
		  ,gl.AccountNumber
		  ,gl.AccountName
		  ,(SELECT COUNT(*) FROM tProject (NOLOCK) WHERE RetainerKey = @RetainerKey) AS AssignedProjects
		  ,glc.GLCompanyName
		  ,glc.GLCompanyID
		  ,glc.GLCompanyID as CompanyID
		  ,cl.ClassID
		  ,cl.ClassName
		  ,o.OfficeID
		  ,o.OfficeName
		  ,CASE Frequency
			WHEN 1 THEN 'Monthly'
			WHen 2 THEN 'Quarterly'
			ELSE 'Yearly'
		  END AS FrequencyName
		  ,CASE LineFormat
			WHEN 1 THEN 'One Line'
			ELSE 'One Line Per Project'
		  END as LineFormatName
	FROM   tRetainer r (NOLOCK)
		INNER JOIN tCompany c (NOLOCK) ON r.ClientKey = c.CompanyKey
		LEFT OUTER JOIN tUser u (NOLOCK) ON r.InvoiceApprovedBy = u.UserKey
		LEFT OUTER JOIN tGLAccount gl (NOLOCK) ON r.SalesAccountKey = gl.GLAccountKey
		LEFT OUTER JOIN tGLCompany glc (NOLOCK) ON r.GLCompanyKey = glc.GLCompanyKey
		LEFT OUTER JOIN tClass cl (NOLOCK) ON r.ClassKey = cl.ClassKey
		LEFT OUTER JOIN tOffice o (nolock) ON r.OfficeKey = o.OfficeKey
		LEFT OUTER JOIN tUser u2 (NOLOCK) on r.ContactKey = u2.UserKey
		LEFT OUTER JOIN tUser u3 (NOLOCK) on r.BillingManagerKey = u3.UserKey
	WHERE  r.RetainerKey = @RetainerKey

	
	RETURN 1
GO
