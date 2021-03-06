USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_AP_Email]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_AP_Email]
   @FileType		varchar(1),
   @EBFileNbr		varchar(6)

AS
   -- AP EFT - Order by Vendor Invoice Nbr - .VchInvcNbr (may be blank)
   SELECT	*
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and EBFileNbr = @EBFileNbr
   ORDER BY	RecSection, DepEntryClass, RecType,
   		ChkAcct, ChkSub, VendID, VchInvcNbr, VchInvcDate, RecordID
GO
