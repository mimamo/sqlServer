USE [MID_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'Cust_Prod_JobDeflts_dbnav'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[Cust_Prod_JobDeflts_dbnav]
GO

CREATE PROCEDURE [dbo].[Cust_Prod_JobDeflts_dbnav] 
	@parm1 Varchar (15),
	@parm2 Varchar (30),
	@parm3 Varchar (10)
 
AS

/*******************************************************************************************************
*   MID_DEV_APP.dbo.Cust_Prod_JobDeflts_dbnav 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute MID_DEV_APP.dbo.Cust_Prod_JobDeflts_dbnav 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins.
********************************************************************************************************/




SELECT xProdJobDefault.*,
a.*,
b.*,
c.[status] 
FROM xProdJobDefault
left outer join PJEmploy a
	on xProdJobDefault.biller = a.employee 
left outer join PJEmploy b
	on xProdJobDefault.approver = b.employee
inner join xIGProdCode c 
	on xProdJobDefault.Code_group = c.Code_group 
	and xProdJobDefault.Product = c.Code_ID
WHERE xProdJobDefault.CustID = @parm1 
	and xProdJobDefault.code_group = @parm2 
	and xProdJobDefault.Product Like @parm3 
order by xProdJobDefault.CustID, xProdJobDefault.Product

GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on Cust_Prod_JobDeflts_dbnav to BFGROUP
go

grant execute on Cust_Prod_JobDeflts_dbnav to MSDSL
go

grant control on Cust_Prod_JobDeflts_dbnav to MSDSL
go

grant execute on Cust_Prod_JobDeflts_dbnav to MSDynamicsSL
go
