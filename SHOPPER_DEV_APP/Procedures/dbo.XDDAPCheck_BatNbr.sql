USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPCheck_BatNbr]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPCheck_BatNbr]
   @BatNbr      varchar(10)
as
   Select 	* from APCheck
   WHERE        BatNbr = @BatNbr
   ORDER BY     BatNbr, Acct, Sub, CheckRefNbr, RecordID
GO
