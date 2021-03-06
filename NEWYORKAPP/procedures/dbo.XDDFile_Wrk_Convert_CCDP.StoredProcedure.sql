USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Convert_CCDP]    Script Date: 12/21/2015 16:01:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Convert_CCDP]
	@EBFileNbr		varchar( 6 ),
	@FileType		varchar( 1 )

AS

Declare @RefNbr		varchar( 10 )

SET @RefNbr = ''
if @FileType = 'E'
	SELECT TOP 1 @RefNbr = W.ChkRefNbr
	FROM XDDFile_Wrk W (nolock) left outer join XDDDepositor D (nolock)
			ON W.Vendid = D.Vendid and D.VendCust = 'V'
	WHERE  EBFileNbr = @EBFileNbr
			and W.FileType = @FileType
			and W.VchDocType = 'AD'
			and rtrim(W.DepEntryClass) = 'CCD+'
			and D.ConvertCCDP_CCD = 1
			
-- Look for AD records
While (@RefNbr <> '')
BEGIN

	if @FileType = 'E'

	BEGIN
		-- Now update all records for this RefNbr
		-- Make CCD and set to 1 record/check
		UPDATE	XDDFile_Wrk 
		SET		DepEntryClass = 'CCD',			-- change from CCD+ to CCD
				DepRecord = 'C'					-- set to 1 record/check
		WHERE  	EBFileNbr = @EBFileNbr
				and FileType = @FileType
				and ChkRefNbr = @RefNbr

		SET @RefNbr = ''
	
		SELECT TOP 1 @RefNbr = W.ChkRefNbr
		FROM XDDFile_Wrk W (nolock) left outer join XDDDepositor D (nolock)
				ON W.Vendid = D.Vendid and D.VendCust = 'V'
		WHERE  EBFileNbr = @EBFileNbr
				and W.FileType = @FileType
				and W.VchDocType = 'AD'
				and rtrim(W.DepEntryClass) = 'CCD+'
				and D.ConvertCCDP_CCD = 1
	END			

END
GO
