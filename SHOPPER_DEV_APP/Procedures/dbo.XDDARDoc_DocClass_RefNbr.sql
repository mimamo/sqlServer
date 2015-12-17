USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_DocClass_RefNbr]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDARDoc_DocClass_RefNbr]
   @DocClass		varchar( 1 ),
   @RefNbr		varchar( 10 )

AS

   SELECT * From ARDoc Where DocClass = @DocClass and refnbr like @RefNbr and CuryDocBal <> 0 order by refnbr
GO
