USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_CCash_Class_byrefnbr1]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_CCash_Class_byrefnbr1    Script Date: 4/7/98 12:30:32 PM ******/
Create Procedure [dbo].[ARDoc_CCash_Class_byrefnbr1] @parm1 varchar ( 15) as
    select * from ardoc where
    custid = @parm1
    and Rlsed = 1
    and doctype IN ('FI','IN','DM','NC','CM','PA','PP')
    and curydocbal > 0
    order by CustId, Rlsed, RefNbr
GO
