USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_All]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Customer_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Customer_All] @parm1 varchar ( 15) as
    Select * from Customer where CustId like @parm1 order by CustId
GO
