select '"MIDWEST"' as 'Company', quotename(ltrim(rtrim(Name)),'"') as VendName
, quotename(ltrim(rtrim(VendId)),'"') as VendID from Vendor where Status = 'A' order by VendId



