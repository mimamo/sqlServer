USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WODeleteBatch]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WODeleteBatch]
	@Module        char (2),
	@BatNbr        char (10)

as
set nocount on

   Delete from Batch Where BatNbr = @BatNbr and Module = @Module
   if (@@error = 0)
	 	print 'Delete Batch complete'

   -- IN Module Delete, only want unreleased trans
   If @Module = 'IN'
   	BEGIN
   	Delete from INTran Where BatNbr = @BatNbr and Rlsed = 0
      Delete from LotSerT Where BatNbr = @BatNbr and Rlsed = 0
      Delete from WOLotSerT Where BatNbr = @BatNbr and Status <> 'R'
   	END
	if (@@error = 0)
	 	print 'Delete INTran complete'
GO
