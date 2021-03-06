USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_ACH]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_ACH]
   @FileType		varchar(1),
   @ComputerName	varchar(21)

AS
   SELECT	*
   FROM		XDDFile_Wrk
   WHERE	FileType = @FileType
   		and ComputerName = @ComputerName
   ORDER BY	RecSection, DepEntryClass, RecType,
   		ChkAcct, ChkSub, VendID, ChkBatNbr, ChkRefNbr, VchDocType DESC, RecordID
GO
