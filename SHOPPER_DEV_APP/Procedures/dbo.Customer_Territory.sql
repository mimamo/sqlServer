USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_Territory]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Customer_Territory    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Customer_Territory] @parm1 varchar (10) as
    Select * from Customer where Territory = @parm1 order by CustId
GO
