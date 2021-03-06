USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_PerPost_Range]    Script Date: 12/21/2015 16:13:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[GLTran_PerPost_Range] @Acct varchar (10), @Sub varchar(24), @LedgerID varchar(10),
   @PerPost varchar (6), @CpnyID varchar(10), @StartBatNbr varchar(10), @StopBatNbr varchar(10) As

   Select * from GLTran
   Where Posted   = 'P'
         and CpnyID   = @CpnyID
         and Acct     = @Acct
         and Sub      = @Sub
         and LedgerID = @LedgerID
         and PerPost  = @PerPost
	 and BatNbr between @StartBatNbr and @StopBatNbr
   Order by BatNbr
GO
