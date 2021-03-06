USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_ACH_Pmt_Applic]    Script Date: 12/21/2015 16:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_ACH_Pmt_Applic]
   @FileType		varchar(1),
   @EBFileNbr		varchar(6)

AS
   SELECT	*
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and EBFileNbr = @EBFileNbr
                and RecSection = '20P'
		and RecType = '10V'
   ORDER BY	RecSection, DepEntryClass, RecType,
   		VchCpnyID, VchCuryID, VendID, ChkAcct, ChkSub, ChkBatNbr, ChkRefNbr, VchDocType DESC, RecordID
GO
