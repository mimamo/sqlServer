USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Acct_Sub_CpnyID]    Script Date: 12/21/2015 16:07:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Acct_Sub_CpnyID]
   @FileType		varchar(1),
   @EBFileNbr		varchar(6)

AS
   SELECT TOP 1	ChkAcct, ChkSub, ChkCpnyID
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and EBFileNbr = @EBFileNbr
   		and RecSection = '20P'
GO
