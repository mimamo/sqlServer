USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_NonReceive_APDocBatNbr]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurchOrd_NonReceive_APDocBatNbr]
    @BatNbr CHAR(10)
AS
    -- PurchOrds used with this POReceipt that not receivable (Drop Ship PO or Regulare PO and have Service for Project purchase type)
    SELECT DISTINCT PurchOrd.*
     FROM APDoc WITH (NOLOCK)
      INNER JOIN PurchOrd WITH (NOLOCK)
	INNER JOIN PurOrdDet WITH (NOLOCK)
         ON PurOrdDet.PONbr = PurchOrd.PONbr
          AND PurOrdDet.PC_Status = 1
          AND (PurchOrd.POType = 'DP' -- Drop Ship
               OR (PurchOrd.POType = 'OR' -- Regular Order
                   AND PurOrdDet.PurchaseType = 'SP')) -- Service for Project
       ON PurchOrd.PONbr = APDoc.PONbr
     WHERE APDoc.BatNbr = @BatNbr
     ORDER BY PurchOrd.PONbr
GO
