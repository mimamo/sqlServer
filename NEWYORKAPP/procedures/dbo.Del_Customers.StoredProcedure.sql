USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Del_Customers]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[Del_Customers] @parm1 varchar (15) as

Delete from Customer where custid = @parm1
GO
