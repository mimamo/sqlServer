USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_AP_2_MCB]    Script Date: 12/21/2015 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_AP_2_MCB]
   @VchRefNbr	varchar( 10 ),
   @VchDocType	varchar( 2 ),
   @VendID	varchar( 15 )

AS

   SELECT	*
   FROM		APDoc (nolock)
   WHERE	VendID = @VendID
   		and RefNbr = @VchRefNbr
   		and DocType = @VchDocType
GO
