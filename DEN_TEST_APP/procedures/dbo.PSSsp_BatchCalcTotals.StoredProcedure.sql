USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSsp_BatchCalcTotals]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSsp_BatchCalcTotals] @BatNbr VARCHAR(10), @CpnyId VARCHAR(10), @Module VARCHAR(2) AS

  DECLARE @DrTotal AS Money
  DECLARE @CrTotal AS Money

  SET NoCount On

  If @Module = 'GL'
    Begin
      SET @DrTotal = (SELECT CONVERT(Money, IsNull(Sum(DRAmt), 0.00)) FROM GLTran WHERE Module = @Module AND BatNbr = @BatNbr AND CpnyId = @CpnyId)
      SET @CrTotal = (SELECT CONVERT(Money, IsNull(Sum(CRAmt), 0.00)) FROM GLTran WHERE Module = @Module AND BatNbr = @BatNbr AND CpnyId = @CpnyId)
    End

  If @Module = 'AR'
    Begin
      SET @DrTotal = (SELECT CONVERT(Money, IsNull(Sum(TranAmt), 0.00)) FROM ARTran WHERE DrCr = 'D' AND BatNbr = @BatNbr AND CpnyId = @CpnyId)
      SET @CrTotal = (SELECT CONVERT(Money, IsNull(Sum(TranAmt), 0.00)) FROM ARTran WHERE DrCr = 'C' AND BatNbr = @BatNbr AND CpnyId = @CpnyId)
    End
  
  If @Module = 'AP'
    Begin
      SET @DrTotal = (SELECT CONVERT(Money, IsNull(Sum(TranAmt), 0.00)) FROM APTran WHERE DrCr = 'D' AND BatNbr = @BatNbr AND CpnyId = @CpnyId)
      SET @CrTotal = (SELECT CONVERT(Money, IsNull(Sum(TranAmt), 0.00)) FROM APTran WHERE DrCr = 'C' AND BatNbr = @BatNbr AND CpnyId = @CpnyId)
    End

  If @Module = 'GL'
  Begin
     UPDATE Batch
       SET CrTot   = @CrTotal,
       DrTot       = @DrTotal,
       CtrlTot     = @CrTotal,
       CuryCtrlTot = @CrTotal,
       CuryCrTot   = @CrTotal,
       CuryDrTot   = @DrTotal
     WHERE Module = @Module 
     AND BatNbr = @BatNbr 
     AND CpnyId = @CpnyId
  End 

  If @Module = 'AR' or @Module = 'AP' 
  Begin
    UPDATE Batch
      SET CrTot   = CONVERT(FLOAT, @CrTotal),
      DrTot       = CONVERT(FLOAT, @DrTotal),
      CtrlTot     = CONVERT(FLOAT, @CrTotal + @DrTotal),
      CuryCtrlTot = CONVERT(FLOAT, @CrTotal + @DrTotal),
      CuryCrTot   = CONVERT(FLOAT, @CrTotal + @DrTotal),
      CuryDrTot   = CONVERT(FLOAT, @CrTotal + @DrTotal)    
    WHERE Module = @Module 
    AND BatNbr = @BatNbr 
    AND CpnyId = @CpnyId
  End
GO
