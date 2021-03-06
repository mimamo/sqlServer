USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_KeepDelete_Email]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_KeepDelete_Email]
   @FileType		varchar (1),
   @EBFileNbr		varchar (6),
   @Acct		varchar (10),
   @SubAcct		varchar (24),
   @VendID		varchar (15),
   @KeepDelete		varchar (1)
AS
   UPDATE		XDDFile_Wrk
   SET			KeepDelete = @KeepDelete
   WHERE		FileType = @FileType
   			and EBFileNbr = @EBFileNbr
   			and ChkAcct = @Acct
   			and ChkSub = @SubAcct
   			and VendID = @VendID
GO
