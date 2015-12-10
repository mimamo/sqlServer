USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLeadGetSpecInfo]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptLeadGetSpecInfo]

	(
		@LeadKey int
	)

AS --Encrypt

select
	ISNULL(l.CustomFieldKey, 0) as CustomFieldKey,
	l.ContactCompanyKey,
	fs.FieldSetName,
	l.Subject
from 
	tLead l (nolock),
	tObjectFieldSet ofs (nolock),
	tFieldSet fs (nolock)
Where
	l.CustomFieldKey = ofs.ObjectFieldSetKey and
	ofs.FieldSetKey = fs.FieldSetKey and
	l.LeadKey = @LeadKey
GO
