USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CCash_Class_bydate]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CCash_Class_bydate    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_CCash_Class_bydate] @parm1 varchar ( 15) as
    select * from ardoc where
    custid = @parm1
    and Rlsed = 1
    and doctype IN ('FI','IN','DM','NC')
    and curydocbal > 0
    order by CustId, Rlsed, DueDate
GO
