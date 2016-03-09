
USE DENVERAPP; 
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH(NOLOCK)
            WHERE NAME = 'DynamicsVendors'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[DynamicsVendors]
GO

CREATE PROCEDURE [dbo].[DynamicsVendors]     

 AS


/*******************************************************************************************************
*   DENVERAPP.dbo.DynamicsVendors 
*
*   Creator:   
*   Date:          
*   
*
*   Notes:         
*                  
*
*   Usage:	
	
	execute DENVERAPP.dbo.DynamicsVendors 

		

		
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/23/2016	Put SSRS query into procedure
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------
if object_id('tempdb.dbo.##DslVendors') is not null drop table ##DslVendors
create table ##DslVendors
(
	Company	varchar(11),
	VendName varchar(1000),
	VendID	varchar(1000),
	[Status] varchar(1),
	primary key clustered (Company, VendID)
)
---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON;

---------------------------------------------
-- body of stored procedure
---------------------------------------------

-- DALLAS Vendors
insert ##DslVendors
(
	Company,
	VendName,
	VendID,
	[Status]
)
select Company = 'DALLAS', 
	VendName = replace(ltrim(rtrim(Name)), '"', ''''),
	VendID =  replace(ltrim(rtrim(VendId)), '"', ''''),
	[Status] 
from DALLASAPP.DBO.Vendor --where Status = 'A'

-- DENVER Vendors
insert ##DslVendors
(
	Company,
	VendName,
	VendID,
	[Status]
)
select Company = 'DENVER', 
	VendName = replace(ltrim(rtrim(Name)), '"', ''''),
	VendID =  replace(ltrim(rtrim(VendId)), '"', ''''),
	[Status] 
from DENVERAPP.DBO.Vendor --where Status = 'A'

-- MIDWEST Vendors
insert ##DslVendors
(
	Company,
	VendName,
	VendID,
	[Status]
)
select Company = 'MIDWEST', 
	VendName = replace(ltrim(rtrim(Name)), '"', ''''),
	VendID =  replace(ltrim(rtrim(VendId)), '"', ''''),
	[Status] 
from MIDWESTAPP.DBO.Vendor --where Status = 'A'

-- LA Vendors
insert ##DslVendors
(
	Company,
	VendName,
	VendID,
	[Status]
)
select Company = 'LA', 
	VendName = replace(ltrim(rtrim(Name)), '"', ''''),
	VendID =  replace(ltrim(rtrim(VendId)), '"', ''''),
	[Status] 
from LAAPP.DBO.Vendor --where Status = 'A'

-- NEWYORK Vendors
insert ##DslVendors
(
	Company,
	VendName,
	VendID,
	[Status]
)
select Company = 'NEWYORK', 
	VendName = replace(ltrim(rtrim(Name)), '"', ''''),
	VendID =  replace(ltrim(rtrim(VendId)), '"', ''''),
	[Status] 
from NEWYORKAPP.DBO.Vendor --where Status = 'A'

-- SHOPPER NY Vendors
insert ##DslVendors
(
	Company,
	VendName,
	VendID,
	[Status]
)
select Company = 'SHOPPERNY', 
	VendName = replace(ltrim(rtrim(Name)), '"', ''''),
	VendID =  replace(ltrim(rtrim(VendId)), '"', ''''),
	[Status] 
from SHOPPERAPP.DBO.Vendor 


select 	Company,
	VendName,
	VendID,
	[Status]
from ##DslVendors
order by Company, VendID

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on DynamicsVendors to BFGROUP
go

grant execute on DynamicsVendors to MSDSL
go

grant control on DynamicsVendors to MSDSL
go

grant execute on DynamicsVendors to MSDynamicsSL
go
