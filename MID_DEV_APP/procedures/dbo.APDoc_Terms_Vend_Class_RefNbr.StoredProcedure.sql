USE [MID_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH (nolock)
            WHERE NAME = 'APDoc_Terms_Vend_Class_RefNbr'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[APDoc_Terms_Vend_Class_RefNbr]
GO

Create Procedure [dbo].[APDoc_Terms_Vend_Class_RefNbr] 
	@parm1 smalldatetime,
	 @parm2 varchar (10) 
	
AS 

/*******************************************************************************************************
*   MID_DEV_APP.dbo.APDoc_Terms_Vend_Class_RefNbr 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute MID_DEV_APP.dbo.APDoc_Terms_Vend_Class_RefNbr 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/



--- Select apdoc.*, Terms.TermsID, Terms.DiscType, Terms.DiscIntrv, Terms.DueType, Terms.DueIntrv, Terms.DiscPct, Vendor.VendID, Vendor.PayDateDflt, Vendor.APAcct, Vendor.APSub from APDoc, Terms, Vendor Where
Select apdoc.*   
from APDoc 
Where APDoc.DocClass = 'R' 
	and APDoc.DocDate <= @parm1 
	and APDoc.RefNbr like @parm2 
	and APDoc.CuryOrigDocAmt = APDoc.CuryDocBal
--- an dAPDoc.Terms *= Terms.TermsId    and
--- APDoc.VendId *= Vendor.VendId
order by APDoc.CuryID, APDoc.DocClass, APDoc.RefNbr
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on APDoc_Terms_Vend_Class_RefNbr to BFGROUP
go

grant execute on APDoc_Terms_Vend_Class_RefNbr to MSDSL
go

grant control on APDoc_Terms_Vend_Class_RefNbr to MSDSL
go

grant execute on APDoc_Terms_Vend_Class_RefNbr to MSDynamicsSL
go