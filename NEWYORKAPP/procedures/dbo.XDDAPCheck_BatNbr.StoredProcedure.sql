USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPCheck_BatNbr]    Script Date: 12/21/2015 16:01:23 ******/
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
