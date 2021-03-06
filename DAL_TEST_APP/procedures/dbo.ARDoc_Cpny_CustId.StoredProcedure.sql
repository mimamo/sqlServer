USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cpny_CustId]    Script Date: 12/21/2015 13:56:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cpny_CustId    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_Cpny_CustId] @parm1 varchar ( 15), @parm2 varchar ( 2), @parm3 varchar ( 10) as
    select * from ardoc where custid = @parm1
    and (doctype = 'PA' or doctype = 'PP' or doctype = @parm2 or doctype = 'DA')
    and curydocbal > 0
    and applbatnbr = ''
    and rlsed = 1
    and cpnyid = @parm3
    order by CustId, DocDate
GO
