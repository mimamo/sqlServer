USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPDoc_eStatus_Blank]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPDoc_eStatus_Blank]
   @Acct		varchar( 10 ),
   @SubAcct		varchar( 24 ),
   @DocType		varchar( 2 ),
   @RefNbr		varchar( 10 )
   
AS

   UPDATE		APDoc
   SET			eStatus = ''   
   WHERE		Acct = @Acct
   			and Sub = @SubAcct
   			and DocType = @DocType
   			and RefNbr = @RefNbr
GO
