USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Customer_ClassId]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Customer_ClassId    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Customer_ClassId] @parm1 varchar ( 6) as
    Select * from Customer where ClassId = @parm1 order by CustId
GO
