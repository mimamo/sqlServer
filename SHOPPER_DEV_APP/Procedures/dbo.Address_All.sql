USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Address_All]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Address_All    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[Address_All] @parm1 varchar ( 10) as
       Select * from Address
           where AddrId like @parm1
           order by AddrId
GO
