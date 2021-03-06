USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CustId_Class_byclass]    Script Date: 12/21/2015 15:49:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CustId_Class_byclass    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_CustId_Class_byclass] @parm1 varchar ( 15) as
    select * from ardoc where custid like @parm1
    and doctype IN ('FI', 'IN', 'DM')
    and curydocbal > 0
    and Rlsed = 1
    order by CustId, DocClass, DocDate
GO
