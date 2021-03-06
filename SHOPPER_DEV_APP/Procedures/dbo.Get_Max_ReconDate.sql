USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Get_Max_ReconDate]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Get_Max_ReconDate   Script Date: 9/6/01 12:49:19 PM ******/
CREATE PROCEDURE [dbo].[Get_Max_ReconDate]
@CpnyID varchar ( 10),
@BankAcct varchar(10),
@BankSub varchar ( 24)

AS

SELECT MAX(ReconDate)
  FROM BankRec
 WHERE CpnyID = @CpnyID
   AND BankAcct = @BankAcct
   AND BankSub = @BankSub
GO
