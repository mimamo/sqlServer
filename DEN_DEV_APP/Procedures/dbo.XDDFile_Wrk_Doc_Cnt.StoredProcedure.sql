USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Doc_Cnt]    Script Date: 12/21/2015 14:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Doc_Cnt]
  	@EBFileNbr	varchar( 6 ),
  	@FileType	varchar( 1 ),
  	@VendCustID	varchar( 15 )
AS

	SELECT		Count(Distinct ChkRefNbr)
	FROM            XDDFile_Wrk (nolock)
	WHERE		EBFileNbr = @EBFileNbr
			and FileType = @FileType
			and VendID = @VendCustID
GO
