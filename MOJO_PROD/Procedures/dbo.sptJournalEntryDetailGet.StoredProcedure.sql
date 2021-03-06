USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryDetailGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryDetailGet]
	@JournalEntryDetailKey int

AS --Encrypt

/*
|| When     Who Rel     What
|| 10/17/07 BSH 8.5     (9659)Get Office, Department
|| 03/27/12 MFT 10.554  Added TargetGLCompany data
*/

		SELECT 
			jed.*,
			gl.AccountNumber,
			gl.AccountName,
			cl.ClassID,
			cl.ClassName,
			c.CompanyName,
			c.CustomerID as ClientID,
			p.ProjectNumber,
		  o.OfficeName,
		  d.DepartmentName,
		  glc.GLCompanyID as TargetGLCompanyID,
		  glc.GLCompanyName as TargetGLCompanyName
		FROM tJournalEntryDetail jed (nolock)
			inner join tGLAccount gl (nolock) on jed.GLAccountKey = gl.GLAccountKey
			left outer join tOffice o (nolock) on jed.OfficeKey = o.OfficeKey
		  left outer join tDepartment d (nolock) on jed.DepartmentKey = d.DepartmentKey
			left outer join tClass cl (nolock) on jed.ClassKey = cl.ClassKey
			left outer join tCompany c (nolock) on jed.ClientKey = c.CompanyKey
			left outer join tProject p (nolock) on jed.ProjectKey = p.ProjectKey
			left outer join tGLCompany glc (nolock) on jed.TargetGLCompanyKey = glc.GLCompanyKey
		WHERE
			jed.JournalEntryDetailKey = @JournalEntryDetailKey

	RETURN 1
GO
