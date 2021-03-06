USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_RcptNbr]    Script Date: 12/21/2015 14:34:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurchOrd_RcptNbr]
    @RcptNbr CHAR(10)
AS
    -- PurchOrds used with this POReceipt
    SELECT DISTINCT PurchOrd.*
     FROM POReceipt WITH (NOLOCK)
      INNER JOIN PurchOrd WITH (NOLOCK)
       ON PurchOrd.PONbr = POReceipt.PONbr
     WHERE POReceipt.RcptNbr = @RcptNbr
     ORDER BY PurchOrd.PONbr
GO
