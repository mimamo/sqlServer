select
LTRIM(RTRIM(VendId)) as SupplierId,
'' as SupplierLocationId,
REPLACE(LTRIM(RTRIM(Name)),',',' ') AS 'SupplierName',
	REPLACE(CASE
			WHEN LEN(LTRIM(RTRIM(Addr1)))>1 AND LEN(LTRIM(RTRIM(Addr2)))>1 
				THEN LTRIM(RTRIM(Addr1)) +', ' + LTRIM(RTRIM(Addr2))
				ELSE LTRIM(RTRIM(Addr1))
		END ,',',' ')AS 'StreetAddress',
REPLACE (LTRIM(RTRIM (City)),',',' ') as City,
State as State,
'USA' as Country,
Zip as PostalCode,
ClassID as SupplierType,
'' as ContactFirstName,
'' as ContactLastName,
Phone as ContactPhoneNumber,
'' as ContactEmail,
'' as PreferredLanguage,
'' as FaxNumber,
'' as OrderRoutingType,
'' as DUNSNumber,
'' as ANNumber,
'' as PaymentType,
'' as Diversity,
'' as MinorityOwned,
'' as WomanOwned,
'' as VeteranOwned,
'' as DiversitySBA8A,
'' as DiversityHUBZone,
'' as DiversitySDB,
'' as DiversityDVO,
'' as DiversityEthnicity,
'' as FlexField1,
'' as FlexField2,
'' as FlexField3

from vendor 
/*
WHERE 
ClassID NOT IN ('EMP','EMP-BELMAR','EMP-FIELD')*/
 