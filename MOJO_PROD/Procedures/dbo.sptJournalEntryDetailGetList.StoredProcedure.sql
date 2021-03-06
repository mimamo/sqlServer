USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptJournalEntryDetailGetList]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptJournalEntryDetailGetList]

	@JournalEntryKey int

AS --Encrypt
/*
|| When     Who Rel     What
|| 6/15/10  GWG 10.530  Added a restrict to not get details that are = 0
|| 03/27/12 MFT 10.554  Added TargetGLCompany data
|| 06/27/12 GHL 10.557  Added GL Companies for GL account and Project 
|| 08/16/12 GHL 10.559  Replaced VisibleGLCompanyKey by RestrictToGLCompany
|| 09/24/14 GHL 10.584  (230615) Allowing now bank accounts with a different currency
||                      for transfers from a foreign bank to another foreign bank
*/
		SELECT 
			jed.*,
			gl.AccountNumber,
			gl.AccountName,
			gl.RestrictToGLCompany,
			gl.AccountType,
			case when gl.AccountType not in (10, 11,20, 23) then je.CurrencyID
			else gl.CurrencyID 
			end as CurrencyID,
			cl.ClassID,
			cl.ClassName,
			c.CompanyName AS ClientName,
			c.CustomerID as ClientID,			
			p.ProjectNumber,
			p.ProjectName,
			p.GLCompanyKey AS ProjectGLCompanyKey,
			o.OfficeID,
			o.OfficeName,
			d.DepartmentName,
		    glc.GLCompanyID as TargetGLCompanyID,
		    glc.GLCompanyName as TargetGLCompanyName
		FROM tJournalEntryDetail jed (nolock)
			inner join tJournalEntry je (nolock) on jed.JournalEntryKey = je.JournalEntryKey
			inner join tGLAccount gl (nolock) on jed.GLAccountKey = gl.GLAccountKey
			left outer join tClass cl (nolock) on jed.ClassKey = cl.ClassKey
			left outer join tCompany c (nolock) on jed.ClientKey = c.CompanyKey
			left outer join tProject p (nolock) on jed.ProjectKey = p.ProjectKey
			left outer join tOffice o (nolock) on jed.OfficeKey = o.OfficeKey
			left outer join tDepartment d (nolock) on jed.DepartmentKey = d.DepartmentKey
			left outer join tGLCompany glc (nolock) on jed.TargetGLCompanyKey = glc.GLCompanyKey
		WHERE
			jed.JournalEntryKey = @JournalEntryKey and jed.JournalEntryKey > 0
		Order By JournalEntryDetailKey

	RETURN 1
GO
