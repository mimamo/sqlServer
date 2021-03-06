USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_FileName_Date_Lookup]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_FileName_Date_Lookup]
	@FileName	varchar( 80 ),
	@FileDate	smalldatetime
AS

	Declare @BatNbr	varchar(10)

	SET @FileName = rtrim(@FileName)
	
	SELECT		@BatNbr = LBBatNbr
	FROM		XDDBatchARLB (nolock)
	WHERE		CHARINDEX(@FileName, FilePathName) > 0
			and FileDate = @FileDate
	
	If @BatNbr IS NULL 		
		SELECT		@BatNbr = LBBatNbr
		FROM		XDDBatchARLBErrors (nolock)
		WHERE		CHARINDEX(@FileName, FilePathName) > 0
				and FileDate = @FileDate

	if @BatNbr IS NULL
		SET @BatNBr = ''
		
	Select @BatNbr
GO
