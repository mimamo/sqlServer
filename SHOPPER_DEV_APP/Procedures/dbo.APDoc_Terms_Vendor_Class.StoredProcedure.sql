USE [SHOPPER_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'APDoc_Terms_Vendor_Class'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[APDoc_Terms_Vendor_Class]
GO

/****** Object:  Stored Procedure dbo.APDoc_Terms_Vendor_Class    Script Date: 4/7/98 12:19:54 PM ******/
/***** Modified 11/4/98 - CSS Removed join to Terms and Vendor.  Needed for 03.510 processing *****/

Create Procedure [dbo].[APDoc_Terms_Vendor_Class] 
	@parm1 smalldatetime as

/*******************************************************************************************************
*   SHOPPER_DEV_APP.dbo.APDoc_Terms_Vendor_Class 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute SHOPPER_DEV_APP.dbo.APDoc_Terms_Vendor_Class 

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
	and APDoc.CuryOrigDocAmt = APDoc.CuryDocBal
--- and APDoc.Terms *= Terms.TermsId    and
--- APDoc.VendId *= Vendor.VendId
order by APDoc.CuryID, APDoc.DocClass, APDoc.RefNbr
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on APDoc_Terms_Vendor_Class to BFGROUP
go

grant execute on APDoc_Terms_Vendor_Class to MSDSL
go

grant control on APDoc_Terms_Vendor_Class to MSDSL
go

grant execute on APDoc_Terms_Vendor_Class to MSDynamicsSL
go