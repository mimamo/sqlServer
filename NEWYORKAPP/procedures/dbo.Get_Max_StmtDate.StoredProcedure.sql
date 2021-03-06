USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Get_Max_StmtDate]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Get_Max_StmtDate   Script Date: 9/6/01 12:49:19 PM ******/
CREATE PROCEDURE [dbo].[Get_Max_StmtDate]
@CpnyID varchar ( 10),
@BankAcct varchar(10),
@BankSub varchar ( 24)

AS

SELECT MAX(StmtDate)
  FROM BankRec
 WHERE CpnyID = @CpnyID
   AND BankAcct = @BankAcct
   AND BankSub = @BankSub
GO
