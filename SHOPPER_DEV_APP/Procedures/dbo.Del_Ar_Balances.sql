USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Del_Ar_Balances]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[Del_Ar_Balances] @parm1 varchar (15) as

Delete from AR_Balances where custid = @parm1
GO
