USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGet]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGet]
  @UserKey int = 0,
  @UserID varchar(100) = NULL
AS --Encrypt

/*
  || When     Who Rel   What
  || 10/04/06 WES 8.35  Added ISNULL(u.AddressKey, c.DefaultAddressKey)
  || 7/17/07  CRG 8.5   (9833) Added UserName.
  || 06/23/08 GHL 10.500 Changed inner join with tCompany c to left outer join for contacts
  ||                    since u.CompanyKey is nullable now
  || 08/01/08 GWG 10.5  Added hooks to the folder
  || 06/18/09 QMD 10.5  Added join to tUserPreference to get Email info
  || 08/25/09 MFT 10.508 Added get by UserID logic
  || 02/09/11 RLB 10.542 (100772)Added vendor sales tax defaults
  || 04/14/11 GWG 10.543 Added default service
  || 08/31/11 GHL 10.547 Added ExpenseApprover name
  || 09/04/12 RLB 10.560 Added ServiceCode
  || 09/19/12 GHL 10.560 (154716) Added credit card approver name 
  || 12/15/13 GWG 10.575 Added Timezone to default over to the company
  || 04/23/14 QMD 10.579 Added UserToken
  || 05/22/14 CRG 10.580 Added DefaultCalendarName
  || 12/03/14 QMD 10.586 Changed UserToken to PublicUserToken
  || 02/10/15 GHL 10.589 Added billing title info for Abelson Taylor
*/
 
 IF @UserKey = 0
 	BEGIN
		SELECT @UserKey = UserKey
		FROM tUser
		WHERE UserID = @UserID
 	END
 	
	SELECT	u.*, 
			ISNULL(u.FirstName, '') + ' ' + ISNULL(u.LastName, '') AS UserName,
			v.VendorID,
			v.CompanyName as VendorName,
			cl.ClassID,
			c.CustomerID as ClientID,
			c.CompanyName,
			c.CustomLogo,
			v.VendorSalesTaxKey,
			v.VendorSalesTax2Key,
			st.SalesTaxID,
			st.SalesTaxName,
			st.TaxRate,
			st.PiggyBackTax,
			st2.SalesTaxID as SaleTax2ID,
			st2.SalesTaxName as SaleTax2Name,
			st2.TaxRate as TaxRate2,
			st2.PiggyBackTax as PiggyBackTax2,
			ad.AddressName,
			ad.Address1,
			ad.Address2,
			ad.Address3,
			ad.City,
			ad.State,
			ad.Country,
			ad.PostalCode,
			c.Phone,
			f.UserKey as FolderUserKey,
			up.EmailMailBox,
			up.EmailUserID,
			up.EmailPassword,
			s.ServiceKey,
			s.Description as ServiceDescription,
			s.ServiceCode,
			ISNULL(uea.FirstName, '') + ' ' + ISNULL(uea.LastName, '') AS ExpenseApproverName,
			ISNULL(ucca.FirstName, '') + ' ' + ISNULL(ucca.LastName, '') AS CreditCardApproverName,
			ISNULL(u.TimeZoneIndex, c.TimeZoneIndex) as TimeZone,
			p.Culture,
			up.PublicUserToken,
			cal.FolderName AS DefaultCalendarName,
			t.TitleID,
			t.TitleName
	FROM	tUser u (nolock)
			left outer join tCompany c (NOLOCK) on u.CompanyKey = c.CompanyKey
			left outer join tCompany v (NOLOCK) on u.VendorKey = v.CompanyKey
			left outer join tClass cl (NOLOCK) on u.ClassKey = cl.ClassKey
			left outer join tAddress ad (nolock) on ISNULL(u.AddressKey, c.DefaultAddressKey) = ad.AddressKey
			left outer join tCMFolder f (nolock) on u.CMFolderKey = f.CMFolderKey
			left outer join tUserPreference up (nolock) on u.UserKey = up.UserKey
			left outer join tSalesTax st (nolock) on v.VendorSalesTaxKey = st.SalesTaxKey
			Left outer join tSalesTax st2 (nolock) on v.VendorSalesTax2Key = st2.SalesTaxKey
			left outer join tService s (nolock) on u.DefaultServiceKey = s.ServiceKey
			left outer join tUser uea (nolock) on u.ExpenseApprover = uea.UserKey
			left outer join tUser ucca (nolock) on u.CreditCardApprover = ucca.UserKey
			left outer join tPreference p (nolock) on ISNULL(u.OwnerCompanyKey, u.CompanyKey) = p.CompanyKey
			left outer join tCMFolder cal (nolock) ON u.DefaultCMFolderKey = cal.CMFolderKey
			left outer join tTitle t (nolock) on u.TitleKey = t.TitleKey
	WHERE	u.UserKey = @UserKey

 RETURN 1
GO
