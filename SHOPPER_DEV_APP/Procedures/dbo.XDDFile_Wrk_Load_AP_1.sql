USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_AP_1]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_AP_1]
   @BatNbr	varchar( 10 ),
   @VendID	varchar( 15 )

AS

   SELECT	A.*, C.*
   FROM		APAdjust A (NoLock) LEFT OUTER JOIN APDoc V (nolock)
		ON A.AdjdRefNbr = V.RefNbr and A.AdjdDocType = V.DocType LEFT OUTER JOIN APDoc C (nolock)
		ON A.AdjgAcct = C.Acct and A.AdjgSub = C.Sub and A.AdjgDocType = C.DocType
   		and A.AdjgRefNbr = C.RefNbr and A.AdjgDocType <> 'ZC' LEFT OUTER JOIN XDDDepositor D (NoLock)
		ON A.VendID = D.VendID and D.VendCust = 'V' 
   WHERE	A.AdjBatnbr = @BatNbr
   		and C.Status <> 'V'
   		and A.VendID LIKE @VendID
   ORDER BY 	A.AdjgAcct, A.AdjgSub,
                A.VendID, A.AdjBatNbr,
                A.AdjgRefNbr, A.AdjdDocType DESC
GO
