USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDFile_Wrk_Load_AP_MCB_2]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDFile_Wrk_Load_AP_MCB_2]
   @BatNbr	varchar( 10 ),
   @RefNbr	varchar( 10 ),
   @DocType	varchar( 2 )
   
AS

   SELECT	*
   FROM		APDoc C (nolock)
   WHERE	C.BatNbr = @BatNbr
   		and C.RefNbr = @RefNbr
   		and C.DocType = @DocType
GO
