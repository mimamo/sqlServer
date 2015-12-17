USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_AR_Email]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_AR_Email]
   @FileType		varchar(1),
   @EBFileNbr		varchar(6)

AS
   -- AR EFT - Order by Company Invoice Nbr - .ChkRefNbr
   SELECT	*
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and EBFileNbr = @EBFileNbr
   ORDER BY	RecSection, DepEntryClass, RecType,
   		ChkAcct, ChkSub, VendID, ChkRefNbr, RecordID
GO
