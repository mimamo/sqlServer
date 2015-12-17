USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_PerEnt_Retention]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_PerEnt_Retention    Script Date: 4/7/98 12:19:55 PM ******/
CREATE PROCEDURE [dbo].[APTran_PerEnt_Retention] @Parm1 varchar (15), @Parm2 varchar (6) AS
	Select * from APTran Where VendId = @Parm1 and
	(PerEnt = @Parm2 Or PerEnt > @Parm2)
	Order by RefNbr, Trantype, LineNbr
GO
