USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDWrkCheckSel_Display_All]    Script Date: 12/21/2015 14:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDWrkCheckSel_Display_All]
   @AccessNbr		smallint,
   @BatNbr		varchar( 10 )

AS

   SELECT	*
   FROM		XDDWrkCheckSel C (nolock) LEFT OUTER JOIN XDDDepositor D (nolock)
			ON C.VendID = D.VendID and D.VendCust = 'V'
   WHERE	C.AccessNbr = @AccessNbr
   			and C.EBBatNbr = @BatNbr
   ORDER BY	C.EBBatNbr DESC, C.VendID, C.RefNbr
GO
