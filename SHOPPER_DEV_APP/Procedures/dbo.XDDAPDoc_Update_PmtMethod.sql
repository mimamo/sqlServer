USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPDoc_Update_PmtMethod]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPDoc_Update_PmtMethod]
   @BatNbr		varchar( 10 ),
   @DocClass		varchar( 1 ),
   @PmtMethodCode	varchar( 1 )
   
AS

   UPDATE	APDoc
   SET		PmtMethod = @PmtMethodCode
   WHERE	BatNbr = @BatNbr
   		and DocClass = @DocClass
		and DocType NOT IN ('MC', 'SC', 'VT')
GO
