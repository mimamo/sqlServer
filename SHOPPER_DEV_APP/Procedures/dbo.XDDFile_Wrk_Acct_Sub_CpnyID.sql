USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Acct_Sub_CpnyID]    Script Date: 12/16/2015 15:55:38 ******/
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
