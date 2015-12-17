USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Cust_Ref_Type2]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Cust_Ref_Type2    Script Date: 4/7/98 12:30:33 PM ******/
Create proc [dbo].[ARDoc_Cust_Ref_Type2] @parm1 varchar ( 15), @parm2 varchar ( 6), @parm3 varchar ( 6) As
Select * from Ardoc where
        ardoc.custid = @parm1 and
        ardoc.docbal = 0 and
        ardoc.rlsed = 1 and
        ardoc.perent <= @parm2 and
        ardoc.perclosed <= @parm3 and
        ardoc.perclosed <> ''
        order by CustID, Doctype, RefNbr
GO
