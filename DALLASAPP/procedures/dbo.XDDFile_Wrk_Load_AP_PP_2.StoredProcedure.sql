USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_AP_PP_2]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_AP_PP_2]
   @VchRefNbr	varchar( 10 ),
   @VchDocType	varchar( 2 ),
   @VendID	varchar( 15 )

AS

   -- Unique index on APDoc
   -- Acct, Sub, DocType, RefNbr, RecordID

   SELECT	*
   FROM		APDoc (nolock)
   WHERE	RefNbr = @VchRefNbr
   		and DocType = @VchDocType
   		and VendID = @VendID
GO
