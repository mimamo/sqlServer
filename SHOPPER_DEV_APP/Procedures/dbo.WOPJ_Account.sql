USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPJ_Account]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPJ_Account]
   @GLAcct     varchar( 10 )
AS
   SELECT      *
   FROM        PJ_Account
   WHERE       GL_Acct = @GLAcct
GO
