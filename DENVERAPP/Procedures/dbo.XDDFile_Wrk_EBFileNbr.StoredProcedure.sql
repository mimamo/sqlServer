USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_EBFileNbr]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_EBFileNbr]
   @FileType		varchar(1),
   @EBFileNbr		varchar(6)

AS
   SELECT	*
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and EBFileNbr = @EBFileNbr
   ORDER BY	RecSection, DepEntryClass, DepISOCntry, RecType,
   		ChkAcct, ChkSub, VendID, ChkBatNbr, ChkRefNbr, VchDocType DESC, RecordID
GO
