USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CpnyId_Class_byDocType]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CpnyId_Class_byDocType    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARDoc_CpnyId_Class_byDocType] @parm1 varchar ( 10), @parm2 varchar ( 15) as
    select * from ardoc where
    cpnyid = @parm1
    and custid = @parm2
    and Rlsed = 1
    and doctype IN ('FI','IN','DM','NC')
    and curydocbal > 0
    order by CustId, Rlsed, DocType
GO
