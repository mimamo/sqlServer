USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_AP_MCB_1]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_AP_MCB_1]
   @BatNbr	varchar( 10 )

AS

   SELECT	*
   FROM		APTran T (NoLock) LEFT OUTER JOIN APDoc V (nolock)
		ON T.VendID = V.VendID and T.CostType = V.DocType and T.UnitDesc = V.RefNbr
   WHERE	T.BatNbr = @BatNbr
   		and T.DrCr = 'S'
   ORDER BY 	T.Acct, T.Sub,
   		T.VendID, T.BatNbr,
   		T.UnitDesc, T.CostType DESC
GO
