USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_VendId_PONbr1]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PurchOrd_VendId_PONbr1]
@parm1 varchar (15),
@parm2 varchar (10)
AS

SELECT * FROM PurchOrd

WHERE VendId = @parm1 AND
      PONbr LIKE @parm2 AND
      POtype IN ('OR', 'DP') AND
      Status IN ('M', 'O', 'P')

ORDER BY VendId, PONbr desc
GO
