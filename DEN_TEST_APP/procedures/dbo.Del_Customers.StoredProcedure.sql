USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Del_Customers]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[Del_Customers] @parm1 varchar (15) as

Delete from Customer where custid = @parm1
GO
