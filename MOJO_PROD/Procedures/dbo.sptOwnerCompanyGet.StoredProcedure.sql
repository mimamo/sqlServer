USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptOwnerCompanyGet]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptOwnerCompanyGet]
	 @CompanyKey int
AS --Encrypt

	
/*
|| When     Who Rel     What
|| 04/25/11 RLB 10.5.4.3 Added for new flex company screen
|| 11/07/13 RLB 10574 (195465) Added CompanyTimeZoneIndex
*/
	
  SELECT c.CompanyKey
		,c.CompanyName
		,c.EINNumber
		,c.StateEINNumber
		,c.WebSite
		,c.Phone
		,c.Fax
		,c.Active
		,c.Comments
		,c.DefaultAddressKey
		,c.BillingAddressKey
		,c.PaymentAddressKey
		,c.TimeZoneIndex,
		ad.Address1 as Address1,		-- For backward compatibility
		ad.Address2 as Address2,		-- For backward compatibility
		ad.Address3 as Address3,		-- For backward compatibility
		ad.City as City, 				-- For backward compatibility
		ad.State as State, 				-- For backward compatibility
		ad.PostalCode as PostalCode, 	-- For backward compatibility
		ad.Country as Country,			-- For backward compatibility
		
		ad.Address1 as DAddress1,
		ad.Address2 as DAddress2,
		ad.Address3 as DAddress3,
		ad.City as DCity, 
		ad.State as DState, 
		ad.PostalCode as DPostalCode, 
		ad.Country as DCountry, 
		ad.AddressName as DAddressName,
		adb.Address1 as DBAddress1,
		adb.Address2 as DBAddress2,
		adb.Address3 as DBAddress3,
		adb.City as DBCity, 
		adb.State as DBState, 
		adb.PostalCode as DBPostalCode, 
		adb.Country as DBCountry, 
		adb.AddressName as DBAddressName
	    
  FROM tCompany c (nolock)
	left outer join tAddress ad (nolock) on c.DefaultAddressKey = ad.AddressKey
	left outer join tAddress adb (nolock) on c.BillingAddressKey = adb.AddressKey

  WHERE
   c.CompanyKey = @CompanyKey
   
   
   SELECT *
	FROM   tAddress (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    Entity IS NULL and CompanyKey > 0
	ORDER BY AddressName
  
  
 RETURN 1
GO
