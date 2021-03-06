USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[UpdateForDeleteSBDocs]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[UpdateForDeleteSBDocs] @BatNbr VARCHAR(10), @CustID VARCHAR(15), @TranType VARCHAR(2),
                                  @OrigDocNbr VARCHAR(10), @RefNbr VARCHAR(10), @SBBalance FLOAT
AS
/* Since we are deleting the SB Document; we need to add the Document back to the existing U Trans. */
Declare @SiteID  VARCHAR(10), @CostType VARCHAR(2)

SELECT @SiteID = SiteID, @CostType = CostType
  FROM ARTRAN
 WHERE BATNBR = @BatNbr
   AND CUSTID = @CustID
   AND REFNBR = @REFNBR
   AND Trantype = 'SB'
   AND DRCR = 'U'
   AND RecordID = (SELECT MAX(RECORDID)
                    FROM ARTRAN
                   WHERE BATNBR = @BatNbr
                     AND CUSTID = @CustID
                     AND REFNBR = @REFNBR
                     AND Trantype = 'SB'
                     AND DRCR = 'U')

UPDATE ARTran SET CuryTxblAmt00 = CuryTxblAmt00 + @SBBalance
 WHERE BatNbr = @BatNbr AND CustID = @CustID
   AND Refnbr = @OrigDocNbr AND CostType = @CostType AND SiteID = @SiteID
   AND DrCr = 'U' AND TranType IN ('PA','PP','CM')
GO
