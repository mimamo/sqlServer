USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Del_Customers]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[Del_Customers] @parm1 varchar (15) as

Delete from Customer where custid = @parm1
GO
