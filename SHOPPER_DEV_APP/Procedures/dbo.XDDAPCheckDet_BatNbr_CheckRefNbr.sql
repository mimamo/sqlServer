USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPCheckDet_BatNbr_CheckRefNbr]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPCheckDet_BatNbr_CheckRefNbr]
   @BatNbr       varchar(10),
   @CheckRefNbr  varchar(10)

AS
   Select        * from APCheckDet
   WHERE         BatNbr = @BatNbr and
                 CheckRefNbr = @CheckRefNbr
   ORDER BY      BatNbr, CheckRefNbr, RecordID
GO
