USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_All]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Customer_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Customer_All] @parm1 varchar ( 15) as
    Select * from Customer where CustId like @parm1 order by CustId
GO
