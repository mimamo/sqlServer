USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Del_Ar_Balances]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[Del_Ar_Balances] @parm1 varchar (15) as

Delete from AR_Balances where custid = @parm1
GO
