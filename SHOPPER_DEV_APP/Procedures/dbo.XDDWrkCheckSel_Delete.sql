USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDWrkCheckSel_Delete]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDWrkCheckSel_Delete]
   @AccessNbr		smallint
AS

   DELETE 
   FROM 	XDDWrkCheckSel 
   WHERE	AccessNbr = @AccessNbr
GO
