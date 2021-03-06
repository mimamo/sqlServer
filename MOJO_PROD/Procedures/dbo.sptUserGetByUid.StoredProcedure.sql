USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserGetByUid]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserGetByUid]
	@Uid VARCHAR(2500),
	@CMFolderKey INT = 0

AS

/*
|| When      Who Rel      What
|| 09/30/13  QMD 10.5.7.3 Created to get user by uid. As an additional check there is an optional cmfolderkey
|| 11/01/13	 QMD 10.5.7.3 Added OriginalVCard field
*/

	SELECT	u.UserKey 
			,u.CompanyKey 
			,u.FirstName 
			,u.MiddleName 
			,u.LastName 
			,u.Salutation 
			,u.Phone1 
			,u.Phone2 
			,u.Cell
			,u.Fax 
			,u.Pager 
			,u.Title 
			,u.Email 	
			,u.OwnerCompanyKey 
			,u.Active 
			,u.ClientVendorLogin 
			,u.DateAdded 
			,u.DateUpdated 
			,u.TimeZoneIndex 
			,u.AddressKey 
			,u.MonthlyCost 
			,u.LastModified 
			,u.OwnerKey 
			,u.CMFolderKey 
			,u.DoNotCall
			,u.DoNotEmail 
			,u.DoNotMail 
			,u.DoNotFax 	
			,u.HomeAddressKey 
			,u.OtherAddressKey 
			,u.ClientDivisionKey 
			,u.ClientProductKey 
			,u.Department 
			,u.UserRole 
			,u.Birthday 
			,u.SpouseName 
			,u.Children
			,u.Anniversary 
			,u.Hobbies 
			,u.Comments 
			,u.UserCompanyName 
			,u.DefaultContactCMFolderKey	
			,u.OriginalVCard
			,CASE ISNULL(m.Uid,'')
				WHEN '' THEN u.Uid
				ELSE m.Uid
			 END AS Uid
			,un.UserFullName
			,bus.Address1 AS BusinessAddressStreet
			,bus.City AS BusinessAddressCity
			,bus.State AS BusinessAddressState
			,bus.PostalCode AS BusinessAddressPostalCode
			,bus.Country AS BusinessAddressCountry
			,home.Address1 AS HomeAddressStreet
			,home.City AS HomeAddressCity
			,home.State AS HomeAddressState
			,home.PostalCode AS HomeAddressPostalCode
			,home.Country AS HomeAddressCountry
			,other.Address1 AS OtherAddressStreet			
			,other.City AS OtherAddressCity
			,other.State AS OtherAddressState
			,other.PostalCode AS OtherAddressPostalCode
			,other.Country AS OtherAddressCountry
			
	FROM	tUser u (NOLOCK) Inner Join vUserName un (NOLOCK) ON u.UserKey = un.UserKey
				LEFT JOIN tUserMapping m (NOLOCK) ON u.UserKey = m.UserKey
				LEFT JOIN tAddress bus (NOLOCK) ON u.AddressKey = bus.AddressKey
				LEFT JOIN tAddress home (NOLOCK) ON u.HomeAddressKey = home.AddressKey
				LEFT JOIN tAddress other (NOLOCK) ON u.OtherAddressKey = other.AddressKey
	WHERE	(
				u.Uid = @Uid 
				OR m.Uid = @Uid
			)
			AND (0 = @CMFolderKey OR u.CMFolderKey = @CMFolderKey)
GO
