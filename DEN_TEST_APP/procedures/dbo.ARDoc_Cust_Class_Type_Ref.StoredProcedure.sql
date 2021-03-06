USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cust_Class_Type_Ref]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cust_Class_Type_Ref    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_Cust_Class_Type_Ref] @parm1 varchar ( 10), @parm2 varchar ( 2), @parm3 varchar ( 10) as
    Select * from ARDoc where CustId like @parm1
        and docclass = 'N'
        and doctype like @parm2
        and RefNbr like @parm3
        and Rlsed = 1
        order by CustId, DocType, RefNbr
GO
