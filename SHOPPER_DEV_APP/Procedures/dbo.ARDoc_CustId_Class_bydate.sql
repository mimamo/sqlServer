USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CustId_Class_bydate]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CustId_Class_bydate    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_CustId_Class_bydate] @parm1 varchar ( 15) as
    select * from ardoc where custid = @parm1
    and Rlsed = 1
    and doctype IN ('FI','IN','DM')
    and curydocbal > 0
    order by DueDate
GO
