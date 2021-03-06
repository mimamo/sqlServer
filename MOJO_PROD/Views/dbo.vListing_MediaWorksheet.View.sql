USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vListing_MediaWorksheet]    Script Date: 12/21/2015 16:17:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vListing_MediaWorksheet]
AS

/*
|| When     Who Rel      What
|| 6/10/13  CRG 10.5.6.9 Created
|| 9/23/13  CRG 10.5.7.2 Added CommissionOnly and Comments
|| 12/11/13 CRG 10.5.7.5 Added Product and Primary Buyer
|| 1/29/14  CRG 10.5.7.6 Added POKind
|| 3/26/14  CRG 10.5.7.8 Added MediaAuth, WorksheetPONumber, AuthorizedBy, AuthorizedDate
|| 7/16/14  GHL 10.5.8.2 Added Single Line per Order and Do not Append New Buys
*/

SELECT	w.MediaWorksheetKey,
		w.CompanyKey,
		w.ClientKey,
		w.ProjectKey,
		w.CreatedByKey,
		w.LastUpdatedBy,
		w.WorksheetID as [Worksheet ID],
		w.WorksheetName as [Worksheet Name],
		CASE w.POKind
			WHEN 1 THEN 'Print'
			WHEN 2 THEN 'Broadcast'
			WHEN 4 THEN 'Interactive'
			WHEN 5 THEN 'OOH'
		END as [Worksheet Type],
		c.CustomerID as [Client ID],
		c.CompanyName as [Client Name],
		p.ProjectNumber as [Project Number],
		p.ProjectName as [Project Name],
		u.UserName as [Created By],
		w.DateCreated as [Date Created],
		u2.UserName as [Last Updated By],
		w.LastUpdateDate as [Last Update Date],
		w.StartDate as [Start Date],
		w.EndDate as [End Date],
		CASE w.Active WHEN 1 THEN 'YES' ELSE 'NO' END as Active,
		CASE w.CommissionOnly WHEN 1 THEN 'YES' ELSE 'NO' END as [Commission Only],
		w.Comments,
		cp.ProductName AS Product,
		u3.UserName AS [Primary Buyer],
		w.POKind,
		w.MediaAuth AS [Media Authorization],
		w.WorksheetPONumber AS [PO Number],
		u4.UserName AS [Authorized By],
		w.AuthorizedDate AS [Authorized Date],
		case when isnull(w.OneBuyPerOrder, 0) = 1 then 'YES' else 'NO' end as [Single Line per Order],
		case when isnull(w.DoNotAppendNewBuys, 0) = 1 then 'YES' else 'NO' end as [Do not Append New Buys]
FROM	tMediaWorksheet w (nolock)
LEFT JOIN tCompany c (nolock) ON w.ClientKey = c.CompanyKey
LEFT JOIN tProject p (nolock) ON w.ProjectKey = p.ProjectKey
LEFT JOIN vUserName u (nolock) ON w.CreatedByKey = u.UserKey
LEFT JOIN vUserName u2 (nolock) ON w.LastUpdatedBy = u2.UserKey
LEFT JOIN tClientProduct cp (nolock) ON w.ClientProductKey = cp.ClientProductKey
LEFT JOIN vUserName u3 (nolock) ON w.PrimaryBuyerKey = u3.UserKey
LEFT JOIN vUserName u4 (nolock) ON w.AuthorizedBy = u4.UserKey
GO
