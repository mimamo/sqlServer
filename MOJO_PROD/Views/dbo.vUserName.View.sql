USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vUserName]    Script Date: 12/21/2015 16:17:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vUserName]
AS

/*
|| When      Who Rel      What
|| 2/5/09    CRG 10.5.0.0 Added Address Info
|| 3/31/09   CRG 10.5.0.0 Added UserID, TimeZoneIndex
|| 5/12/09   CRG 10.5.0.0 Added DepartmentKey, OfficeKey
|| 5/20/09   CRG 10.5.0.0 Added ClientVendorLogin, HourlyRate, and Initials
|| 12/20/10  GHL 10.5.3.9 Added subscription fields to diary and todo
|| 12/20/10  CRG 10.5.3.9 Added DefaultServiceKey 
|| 05/30/12  GHL 10.5.5.6 Added Contractor for new search mode on contact lookup
||                        Added GLCompanyKey for other lookups
|| 01/28/15  GHL 10.5.8.8 Added title for Abelson Taylor
*/

SELECT	UserKey, 
		u.CompanyKey, 
		u.GLCompanyKey, 
		u.OwnerCompanyKey, 
		u.Active, 
		LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,''))) AS UserName,
		case 
			when MiddleName is null then LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,''))) 
			else LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + SUBSTRING(MiddleName, 0, 1) + ' ' + ISNULL(LastName,''))) 
		end as UserFullName,
		ISNULL(c.CompanyName, u.UserCompanyName) as CompanyName, 
		u.CMFolderKey, 
		u.OwnerKey, 
		u.Phone1, 
		u.Cell, 
		u.Email, 
		u.Title, 
		u.UserRole, 
		u.DefaultCalendarColor, 
		u.AddressKey, 
		u.Fax,
		ad.Address1,
		ad.Address2,
		ad.Address3,
		ad.City,
		ad.State,
		ad.Country,
		ad.PostalCode,
		u.UserID,
		u.TimeZoneIndex,
		u.DepartmentKey,
		u.OfficeKey,
		u.ClientVendorLogin,
		u.HourlyRate,
		isnull(u.SubscribeDiary, 0) As SubscribeDiary,
		isnull(u.SubscribeToDo, 0) As SubscribeToDo,
		isnull(u.DeliverableReviewer, 0) As DeliverableReviewer,
		isnull(u.DeliverableNotify, 0) As DeliverableNotify,		 
		SUBSTRING(ISNULL(u.FirstName, ''),1,1) + SUBSTRING(ISNULL(u.MiddleName, ''),1,1) + SUBSTRING(ISNULL(u.LastName, ''),1,1) AS Initials,
		u.DefaultServiceKey,
		u.Contractor,
		u.TitleKey
FROM tUser u (nolock)
left outer join tCompany c (nolock) on u.CompanyKey = c.CompanyKey
LEFT JOIN tAddress ad (nolock) on ISNULL(u.AddressKey, c.DefaultAddressKey) = ad.AddressKey
GO
