USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetNextBOLNbr]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDGetNextBOLNbr]  AS
--This Proc will determine and return the Next valid BOL Number from the EDShipSetupTable
Declare @BOLNbr varchar(20)
Declare @NextNum int
Declare Setup_csr Cursor For
Select LastBOL from ANSetup
Open Setup_csr
Begin Tran
Fetch Next From Setup_Csr into  @BOLNbr
--Add 1 to the LastBOL used to get the next available Id
Select @NextNum = (Cast(@BOLNbr as Int) + 1)
Select @BOLNbr = Replicate('0',20 - Len(Rtrim(LTrim(str(@NextNum))))) + ltrim(rtrim(str(@NextNum)))
--Update the EDShipSetup table with the new BOLNBR
Update ANSetup set LastBOL = @BOLNbr  Where Current of Setup_csr
Commit Tran
Select @BOLNbr
Close Setup_csr
Deallocate Setup_csr
Return(0)
GO
