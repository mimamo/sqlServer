USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCMFolderItemsGet]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptCMFolderItemsGet]
(
	@userKey INT,
	@companyKey INT,
	@cmFolderKey INT,
	@lastModifiedDate DATETIME,
	@application VARCHAR(100) = ''
)

As --Encrypt

  /*
  || When     Who Rel       What
  || 06/26/08 QMD 10.5      Created for initial Release of 10.5
  || 09/14/09 QMD 10.5.1.0  Added clause for other syncs
  ||                        Added clause for no folder sync
  || 09/22/09 QMD 10.5.1.1  Added Security Group check
  || 02/15/11 QMD 10.5.4.1  Added logic to use the Include In SyncML option
  || 08/15/12 QMD 10.5.5.9  Added logic to sync contacts with google
  || 08/24/12 QMD 10.5.5.9  Added street2 and street3 for google sync
  || 09/12/12 KMC 10.5.6.0  Added GoogleContacts application option
  || 10/11/12 QMD 10.5.6.1  Added street2 and street3 to all queries
  || 05/07/13 QMD 10.5.6.8  Added a replace for a odd character
  || 09/27/13 QMD 10.5.7.3  Added carddav to in
*/

DECLARE @canEdit TINYINT 
DECLARE @canAdd TINYINT

SET @canEdit = 0
SET @canAdd = 0

IF @application in ( 'syncml' )
   BEGIN
   
		IF @cmFolderKey = -1 
		   BEGIN 
				exec @canEdit = sptUserGetRight @userKey, 'editOtherContacts'
				exec @canAdd = sptUserGetRight @userKey, 'addContacts'
				
				-- if can edit others then return everything with ownerCompanyKey
				IF @canEdit = 1 
					-- Get the contacts for the given companyKey
					SELECT	CMFolderKey = @cmFolderKey, u.* , comp.CompanyName,

							Replace(bus.Address1,'',' ')AS BusinessStreet,
							Replace(bus.Address2,'',' ') AS BusinessStreet2,
							Replace(bus.Address3,'',' ') AS BusinessStreet3,							
							bus.City AS BusinessCity, 
							bus.State AS BusinessState,
							bus.PostalCode AS BusinessPostalCode,
							bus.Country AS BusinessCountry,

							Replace(home.Address1,'',' ') AS HomeStreet,
							Replace(home.Address2,'',' ') as HomeStreet2,
							Replace(home.Address3,'',' ') as HomeStreet3,							
							home.City AS HomeCity, 
							home.State AS HomeState,
							home.PostalCode AS HomePostalCode,
							home.Country AS HomeCountry,

							Replace(other.Address1,'',' ') AS OtherStreet,
							other.City AS OtherCity, 
							other.State AS OtherState,
							other.PostalCode AS OtherPostalCode,
							other.Country AS OtherCountry

					FROM	tUser u (NOLOCK)
											LEFT JOIN tCompany comp (NOLOCK) ON u.CompanyKey = comp.CompanyKey
											LEFT JOIN tAddress bus (NOLOCK) ON bus.AddressKey = u.AddressKey
											LEFT JOIN tAddress home (NOLOCK) ON home.AddressKey = u.HomeAddressKey
											LEFT JOIN tAddress other (NOLOCK) ON other.AddressKey = u.OtherAddressKey
					WHERE	u.LastModified > @lastModifiedDate
							AND u.OwnerCompanyKey = @companyKey
									
				ELSE IF @canAdd = 1
					-- Get items for only the userKey passed in
					SELECT	CMFolderKey = @cmFolderKey, u.* , comp.CompanyName,

							Replace(bus.Address1,'',' ') AS BusinessStreet,
							Replace(bus.Address2,'',' ') AS BusinessStreet2,
							Replace(bus.Address3,'',' ') AS BusinessStreet3,							
							bus.City AS BusinessCity, 
							bus.State AS BusinessState,
							bus.PostalCode AS BusinessPostalCode,
							bus.Country AS BusinessCountry,

							Replace(home.Address1,'',' ') AS HomeStreet,
							Replace(home.Address2,'',' ') as HomeStreet2,
							Replace(home.Address3,'',' ') as HomeStreet3,								
							home.City AS HomeCity, 
							home.State AS HomeState,
							home.PostalCode AS HomePostalCode,
							home.Country AS HomeCountry,

							Replace(other.Address1,'',' ') AS OtherStreet,
							Replace(other.Address2,'',' ') AS OtherStreet2,
							Replace(other.Address3,'',' ') AS OtherStreet3,								
							other.City AS OtherCity, 
							other.State AS OtherState,
							other.PostalCode AS OtherPostalCode,
							other.Country AS OtherCountry

					FROM	tUser u (NOLOCK)
											LEFT JOIN tCompany comp (NOLOCK) ON u.CompanyKey = comp.CompanyKey
											LEFT JOIN tAddress bus (NOLOCK) ON bus.AddressKey = u.AddressKey
											LEFT JOIN tAddress home (NOLOCK) ON home.AddressKey = u.HomeAddressKey
											LEFT JOIN tAddress other (NOLOCK) ON other.AddressKey = u.OtherAddressKey
					WHERE	u.LastModified > @lastModifiedDate
							AND u.OwnerKey = @userKey
							AND u.OwnerCompanyKey = @companyKey
			END					
		ELSE		
   			-- Get the folders and items for the userkey 	
			SELECT	c.CMFolderKey, u.* , comp.CompanyName,

					Replace(bus.Address1,'',' ') AS BusinessStreet,
					Replace(bus.Address2,'',' ') AS BusinessStreet2,
					Replace(bus.Address3,'',' ') AS BusinessStreet3,					
					bus.City AS BusinessCity, 
					bus.State AS BusinessState,
					bus.PostalCode AS BusinessPostalCode,
					bus.Country AS BusinessCountry,

					Replace(home.Address1,'',' ') AS HomeStreet,
					Replace(home.Address2,'',' ') as HomeStreet2,
					Replace(home.Address3,'',' ') as HomeStreet3,					
					home.City AS HomeCity, 
					home.State AS HomeState,
					home.PostalCode AS HomePostalCode,
					home.Country AS HomeCountry,

					Replace(other.Address1,'',' ') AS OtherStreet,
					Replace(other.Address2,'',' ') AS OtherStreet2,
					Replace(other.Address3,'',' ') AS OtherStreet3,					
					other.City AS OtherCity, 
					other.State AS OtherState,
					other.PostalCode AS OtherPostalCode,
					other.Country AS OtherCountry

			FROM	tCMFolder c (NOLOCK) INNER JOIN tUser u (NOLOCK) ON u.CMFolderKey = c.CMFolderKey
									LEFT JOIN tCompany comp (NOLOCK) ON u.CompanyKey = comp.CompanyKey
									LEFT JOIN tAddress bus (NOLOCK) ON bus.AddressKey = u.AddressKey
									LEFT JOIN tAddress home (NOLOCK) ON home.AddressKey = u.HomeAddressKey
									LEFT JOIN tAddress other (NOLOCK) ON other.AddressKey = u.OtherAddressKey
			WHERE	(c.CMFolderKey = @cmFolderKey OR c.CMFolderKey IN (SELECT CMFolderKey FROM tCMFolderIncludeInSync WHERE UserKey = @userKey))
					AND u.LastModified > @lastModifiedDate
					AND c.CompanyKey = @companyKey
					AND ( 
						  c.UserKey = @userKey 
							OR 
						  EXISTS (SELECT EntityKey 
								  FROM	 tCMFolderSecurity 
								  WHERE	 (CanView = 1 OR CanAdd = 1) 
										 AND Entity = 'tUser'
										 AND CMFolderKey = c.CMFolderKey)
							OR
						  EXISTS (SELECT EntityKey
								  FROM tCMFolderSecurity fs (NOLOCK) INNER JOIN tUser u (NOLOCK) ON fs.EntityKey = u.SecurityGroupKey
								  WHERE	 (CanView = 1 OR CanAdd = 1) 
										 AND fs.Entity = 'tSecurityGroup'
										 AND fs.CMFolderKey = c.CMFolderKey)		
							 )				
   END
ELSE IF @application in ( 'carddav' )  
   BEGIN
	-- Get the folders and items for the userkey 	
			SELECT	c.CMFolderKey, u.* , comp.CompanyName,

					Replace(bus.Address1,'',' ') AS BusinessStreet,
					Replace(bus.Address2,'',' ') AS BusinessStreet2,
					Replace(bus.Address3,'',' ') AS BusinessStreet3,					
					bus.City AS BusinessCity, 
					bus.State AS BusinessState,
					bus.PostalCode AS BusinessPostalCode,
					bus.Country AS BusinessCountry,

					Replace(home.Address1,'',' ') AS HomeStreet,
					Replace(home.Address2,'',' ') as HomeStreet2,
					Replace(home.Address3,'',' ') as HomeStreet3,					
					home.City AS HomeCity, 
					home.State AS HomeState,
					home.PostalCode AS HomePostalCode,
					home.Country AS HomeCountry,

					Replace(other.Address1,'',' ') AS OtherStreet,
					Replace(other.Address2,'',' ') AS OtherStreet2,
					Replace(other.Address3,'',' ') AS OtherStreet3,					
					other.City AS OtherCity, 
					other.State AS OtherState,
					other.PostalCode AS OtherPostalCode,
					other.Country AS OtherCountry

			FROM	tCMFolder c (NOLOCK) INNER JOIN tUser u (NOLOCK) ON u.CMFolderKey = c.CMFolderKey
									LEFT JOIN tCompany comp (NOLOCK) ON u.CompanyKey = comp.CompanyKey
									LEFT JOIN tAddress bus (NOLOCK) ON bus.AddressKey = u.AddressKey
									LEFT JOIN tAddress home (NOLOCK) ON home.AddressKey = u.HomeAddressKey
									LEFT JOIN tAddress other (NOLOCK) ON other.AddressKey = u.OtherAddressKey
			WHERE	c.CMFolderKey = @cmFolderKey 
					AND u.LastModified > @lastModifiedDate
					AND c.CompanyKey = @companyKey
					AND ( 
						  c.UserKey = @userKey 
							OR 
						  EXISTS (SELECT EntityKey 
								  FROM	 tCMFolderSecurity 
								  WHERE	 (CanView = 1 OR CanAdd = 1) 
										 AND Entity = 'tUser'
										 AND CMFolderKey = c.CMFolderKey)
							OR
						  EXISTS (SELECT EntityKey
								  FROM tCMFolderSecurity fs (NOLOCK) INNER JOIN tUser u (NOLOCK) ON fs.EntityKey = u.SecurityGroupKey
								  WHERE	 (CanView = 1 OR CanAdd = 1) 
										 AND fs.Entity = 'tSecurityGroup'
										 AND fs.CMFolderKey = c.CMFolderKey)		
							 )			

   END
ELSE IF @application in ('google', 'googlecontacts')
	BEGIN
		-- Get the folders and items for the userkey 
		SELECT	c.CMFolderKey, s.FolderID, s.LastModified AS FolderLastModified, s.LastSync AS FolderLastSync, s.SyncDirection, u.* , comp.CompanyName,

				bus.Address1 AS BusinessStreet,
				bus.Address2 AS BusinessStreet2,
				bus.Address3 AS BusinessStreet3,
				bus.City AS BusinessCity, 
				bus.State AS BusinessState,
				bus.PostalCode AS BusinessPostalCode,
				bus.Country AS BusinessCountry,

				home.Address1 AS HomeStreet,
				home.Address2 as HomeStreet2,
				home.Address3 as HomeStreet3,
				home.City AS HomeCity, 
				home.State AS HomeState,
				home.PostalCode AS HomePostalCode,
				home.Country AS HomeCountry,

				other.Address1 AS OtherStreet,
				other.Address2 AS OtherStreet2,
				other.Address3 AS OtherStreet3,
				other.City AS OtherCity, 
				other.State AS OtherState,
				other.PostalCode AS OtherPostalCode,
				other.Country AS OtherCountry

		FROM	tCMFolder c (NOLOCK) INNER JOIN tSyncFolder s (NOLOCK) ON c.GoogleSyncFolderKey = s.SyncFolderKey
								INNER JOIN tUser u (NOLOCK) ON u.CMFolderKey = c.CMFolderKey
								LEFT JOIN tCompany comp (NOLOCK) ON u.CompanyKey = comp.CompanyKey
								LEFT JOIN tAddress bus (NOLOCK) ON bus.AddressKey = u.AddressKey
								LEFT JOIN tAddress home (NOLOCK) ON home.AddressKey = u.HomeAddressKey
								LEFT JOIN tAddress other (NOLOCK) ON other.AddressKey = u.OtherAddressKey
		WHERE	c.CMFolderKey = @cmFolderKey
				AND u.LastModified > @lastModifiedDate
				AND c.CompanyKey = @companyKey
				AND ( 
					  c.UserKey = @userKey 
						OR 
					  EXISTS (SELECT EntityKey 
							  FROM	 tCMFolderSecurity 
							  WHERE	 (CanView = 1 OR CanAdd = 1) 
									 AND Entity = 'tUser'
									 AND CMFolderKey = c.CMFolderKey)
						OR
					  EXISTS (SELECT EntityKey
							  FROM tCMFolderSecurity fs (NOLOCK) INNER JOIN tUser u (NOLOCK) ON fs.EntityKey = u.SecurityGroupKey
							  WHERE	 (CanView = 1 OR CanAdd = 1) 
									 AND fs.Entity = 'tSecurityGroup'
									 AND fs.CMFolderKey = c.CMFolderKey)									 
					 )
   END
ELSE
   BEGIN
		-- Get the folders and items for the userkey 
		SELECT	c.CMFolderKey, s.FolderID, s.LastModified AS FolderLastModified, s.LastSync AS FolderLastSync, s.SyncDirection, u.* , comp.CompanyName,

				bus.Address1 AS BusinessStreet,
				bus.Address2 AS BusinessStreet2,
				bus.Address3 AS BusinessStreet3,
				bus.City AS BusinessCity, 
				bus.State AS BusinessState,
				bus.PostalCode AS BusinessPostalCode,
				bus.Country AS BusinessCountry,

				home.Address1 AS HomeStreet,
				home.Address2 as HomeStreet2,
				home.Address3 as HomeStreet3,				
				home.City AS HomeCity, 
				home.State AS HomeState,
				home.PostalCode AS HomePostalCode,
				home.Country AS HomeCountry,

				other.Address1 AS OtherStreet,
				other.Address2 AS OtherStreet2,
				other.Address3 AS OtherStreet3,				
				other.City AS OtherCity, 
				other.State AS OtherState,
				other.PostalCode AS OtherPostalCode,
				other.Country AS OtherCountry

		FROM	tCMFolder c (NOLOCK) INNER JOIN tSyncFolder s (NOLOCK) ON c.SyncFolderKey = s.SyncFolderKey
								INNER JOIN tUser u (NOLOCK) ON u.CMFolderKey = c.CMFolderKey
								LEFT JOIN tCompany comp (NOLOCK) ON u.CompanyKey = comp.CompanyKey
								LEFT JOIN tAddress bus (NOLOCK) ON bus.AddressKey = u.AddressKey
								LEFT JOIN tAddress home (NOLOCK) ON home.AddressKey = u.HomeAddressKey
								LEFT JOIN tAddress other (NOLOCK) ON other.AddressKey = u.OtherAddressKey
		WHERE	c.CMFolderKey = @cmFolderKey
				AND u.LastModified > @lastModifiedDate
				AND c.CompanyKey = @companyKey
				AND ( 
					  c.UserKey = @userKey 
						OR 
					  EXISTS (SELECT EntityKey 
							  FROM	 tCMFolderSecurity 
							  WHERE	 (CanView = 1 OR CanAdd = 1) 
									 AND Entity = 'tUser'
									 AND CMFolderKey = c.CMFolderKey)
						OR
					  EXISTS (SELECT EntityKey
							  FROM tCMFolderSecurity fs (NOLOCK) INNER JOIN tUser u (NOLOCK) ON fs.EntityKey = u.SecurityGroupKey
							  WHERE	 (CanView = 1 OR CanAdd = 1) 
									 AND fs.Entity = 'tSecurityGroup'
									 AND fs.CMFolderKey = c.CMFolderKey)									 
					 )
   END
GO
