USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vQuoteDetail]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        View [dbo].[vQuoteDetail]
as

/*
|| When     Who Rel  What
|| 11/28/06 CRG 8.35 Added ProjectNameNumber field which concatenates Project Number and Project Name for display on the printed quote.
|| 07/12/07 GWG 8.43 Modified projectnamenumber to just show project number cause the number and name cause it to wrap
|| 11/20/07 BSH 8.5  Added Phone and Fax to show up along with the address.
|| 10/22/08 GHL 10.5    (37963) Added company address on the quote header
||					     I had a chat with Mike and we decided to do it this way.
||                       I will put an address on the header of the quote. 
||                       If this is not null, we will get the address from it 
||                       If the GL company is not null, get the Printed Name from it in lieu of the company name 
||                       If the GL company is not null, get the phone # from it in lieu of the company phone
*/

SELECT 
	tQuote.CompanyKey, 
	
	case when isnull(tQuote.GLCompanyKey, 0) > 0 then gl.PrintedName else tCompany.CompanyName end as CompanyName, 
	case when isnull(tQuote.GLCompanyKey, 0) > 0 then gl.Phone else tCompany.Phone end as CPhone,
    case when isnull(tQuote.GLCompanyKey, 0) > 0 then gl.Fax else tCompany.Fax end as CFax, 
	
	case when isnull(tQuote.CompanyAddressKey, 0) > 0 then a_q.Address1 else a_c.Address1 end as Address1, 
	case when isnull(tQuote.CompanyAddressKey, 0) > 0 then a_q.Address2 else a_c.Address2 end as Address2, 
	case when isnull(tQuote.CompanyAddressKey, 0) > 0 then a_q.Address3 else a_c.Address3 end as Address3, 
	case when isnull(tQuote.CompanyAddressKey, 0) > 0 then a_q.City else a_c.City end as City, 
	case when isnull(tQuote.CompanyAddressKey, 0) > 0 then a_q.State else a_c.State end as State, 
	case when isnull(tQuote.CompanyAddressKey, 0) > 0 then a_q.PostalCode else a_c.PostalCode end as PostalCode,
	
	tQuote.QuoteKey, 
	tQuote.QuoteNumber, 
	tProject.ProjectName, 
	tProject.ProjectNumber,
	tQuote.Subject, 
	tQuote.QuoteDate, 
	tQuote.DueDate, 
	tQuote.Description, 
	tQuote.Status as QuoteStatus,
	tQuote.CustomFieldKey,
	tQuote.MultipleQty,
	tQuote.Quote1,
	tQuote.Quote2,
	tQuote.Quote3,
	tQuote.Quote4,
	tQuote.Quote5,
 	tQuote.Quote6,
	tQuoteDetail.LineNumber, 
	tQuoteDetail.ShortDescription, 
	tQuoteDetail.LongDescription, 
	tQuoteDetail.Quantity, 
	tQuoteDetail.UnitDescription, 
	tQuoteDetail.CustomFieldKey AS DetailCustomFieldKey, 
	tCompany1.CompanyName AS vCompanyName, 
	a_c1.Address1 AS vAddress1, 
	a_c1.Address2 AS vAddress2, 
	a_c1.Address3 AS vAddress3, 
	a_c1.City AS vCity, 
	a_c1.State AS vState, 
	a_c1.PostalCode AS vPostalCode, 
	tQuoteReply.QuoteReplyKey,
	tQuoteReply.Status as ReplyStatus,
	tQuoteReply.VendorKey as ReplyVendorKey,
	(Select qdr.Comments from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as Comments,
	(Select qdr.UnitCost from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as UnitCost,
	(Select qdr.TotalCost from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as TotalCost,
	(Select qdr.TotalCost2 from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as TotalCost2,
	(Select qdr.TotalCost3 from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as TotalCost3,
	(Select qdr.TotalCost4 from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as TotalCost4,
	(Select qdr.TotalCost5 from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as TotalCost5,
	(Select qdr.TotalCost6 from tQuoteReplyDetail qdr (nolock) Where qdr.QuoteDetailKey = tQuoteDetail.QuoteDetailKey and qdr.QuoteReplyKey = tQuoteReply.QuoteReplyKey) as TotalCost6,
	stext.StandardText as HeaderText,
	stext2.StandardText as FooterText,
	ISNULL(tProject.ProjectNumber, '') AS ProjectNameNumber
	--ISNULL(tProject.ProjectNumber, '') + '-' + ISNULL(tProject.ProjectName, '') AS ProjectNameNumber
FROM
	tQuote
	left outer join tQuoteDetail on tQuote.QuoteKey = tQuoteDetail.QuoteKey
	inner join tCompany on tQuote.CompanyKey = tCompany.CompanyKey
	left outer join tProject on tQuote.ProjectKey = tProject.ProjectKey
	left outer join tQuoteReply on tQuote.QuoteKey = tQuoteReply.QuoteKey
	left outer join tCompany tCompany1 on tQuoteReply.VendorKey = tCompany1.CompanyKey
	left outer join tAddress a_c (nolock) on tCompany.DefaultAddressKey = a_c.AddressKey
	left outer join tAddress a_c1 (nolock) on tCompany1.DefaultAddressKey = a_c1.AddressKey
	LEFT OUTER JOIN tAddress a_q (nolock) ON tQuote.CompanyAddressKey = a_q.AddressKey  
 	Left Outer Join tStandardText stext (nolock) on tQuote.HeaderTextKey = stext.StandardTextKey
	Left Outer Join tStandardText stext2 (nolock) on tQuote.FooterTextKey = stext2.StandardTextKey
	Left Outer Join tGLCompany gl (nolock) on tQuote.GLCompanyKey = gl.GLCompanyKey
GO
